#! groovy

pipeline {
    agent { label "dev-data-warehouse-deploy-agent" }
    parameters {
        string(name: "git_branch", defaultValue: "", description: "Enter the name of the branch to build. E.g. master")
        choice(name: "environment", description: "Choose which environment to run on.",
            choices: ["qa", "prod"]
        )
    }
    options {
        ansiColor("xterm")
        throttleJobProperty(
            // https://javadoc.jenkins.io/plugin/throttle-concurrents/
            limitOneJobWithMatchingParams: true,
            throttleEnabled: true,
            throttleOption: 'project',
            paramsToUseForLimit: 'environment'
        )
    }
    environment {
        // just for notifications
        ZOOM_TOKEN_STATUS = credentials('zoom-token-bi-jenkins')
        ZOOM_WEBHOOK_STATUS = credentials('zoom-webhook-bi-jenkins')
        ZOOM_TOKEN_ALARM = credentials('zoom-token-bi-alerts')
        ZOOM_WEBHOOK_ALARM = credentials('zoom-webhook-bi-alerts')
    }
    stages {
        stage('Notify') {
            steps {
                zoom('STARTED')
            }
        }
        stage("Prepare aws cli") {
            environment {
                AWS_PROFILE = "${params.environment}"
            }
            steps {
                sh "(mkdir ~/.aws) || true"
                sh "mv ./integ/aws-cli-config/deploy.config ~/.aws/config"
            }
        }
        stage("Prepare Docker") {
            steps {
                sh '''docker stop $(docker ps -a -q) || true'''
                sh '''docker rm $(docker ps -a -q) || true'''
            }
        }
        stage("Build Docker images") {
            steps {
                sh "./integ/scripts/s3-artifact-download.sh './docker/pentaho/install' 'pdi-ce-9.0.0.0-423.zip' 'data-warehouse/pdi-ce-9.0.0.0-423.zip'"
                dir("./docker") {
                    sh "./docker-rebuild.sh"
                }
            }
        }
        stage("Deploy to environment") {
            environment {
                AWS_PROFILE = "${params.environment}"
            }
            steps {
                sh "integ/scripts/events-disable-triggers.sh ${params.environment}"
                dir("./docker") {
                    sh "./run-migration.sh ${params.environment}"
                    sh "./push-image.sh ${params.environment} pentaho"
                    sh "./push-image.sh ${params.environment} etl"
                }
            }
        }
        stage("Deploy Infrastructure") {
            // this will enable all managed event triggers
            steps {
                build job: 'bi-ops-edw-infrastructure-deploy',
                    propagate: true,
                    wait: true,
                    parameters: [
                        string(name: 'git_branch', value: params.git_branch),
                        string(name: 'environment', value: params.environment),
                        booleanParam(name: 'auto_apply', value: true)
                    ]
            }
        }
    }
    post {
        always {
            zoom(currentBuild.currentResult)
        }
        unsuccessful {
            zoomAlarm(currentBuild.currentResult)
        }
    }
}

def zoom(status) {
    wrap([$class: 'BuildUser']) {
        zoomSend(
            authToken: env.ZOOM_TOKEN_STATUS,
            webhookUrl: env.ZOOM_WEBHOOK_STATUS,
            message: "${env.JOB_NAME} #${currentBuild.number} for ${params.app_env} - ${status}\n" +
                "Submitted by ${env.BUILD_USER} for ${params.git_branch}"
        )
    }
}

def zoomAlarm(status) {
    wrap([$class: 'BuildUser']) {
        zoomSend(
            authToken: env.ZOOM_TOKEN_ALARM,
            webhookUrl: env.ZOOM_WEBHOOK_ALARM,
            message: "${env.JOB_NAME} #${currentBuild.number} for ${params.app_env} - ${status}\n" +
                "Submitted by ${env.BUILD_USER} for ${params.git_branch}"
        )
    }
}
