#! groovy

pipeline {
    agent { label "dev-data-warehouse-deploy-agent" }
    parameters {
        string(name: "git_branch", defaultValue: "", description: "Enter the name of the branch to build. E.g. master")
        choice(name: "environment", description: "Choose which environment to run on.",
            choices: ["qa", "prod"]
        )

        // special control options for EDW deploy
        booleanParam(name: "clear_pending", defaultValue: false, description: "Purge the SQS queues on deploy.")
        booleanParam(name: "stop_jobs", defaultValue: false, description: "Stop running Step Functions on deploy.")

        // Octane actions
        string(name: 'octane_git_branch', defaultValue: "prod-release", description: "Git branch to use with Octane.")
        choice(name: 'octane_environment', description: "Environment to use with Octane",
            choices: ["cert", "prod"]
        )
        booleanParam(name: "start_dms", defaultValue: false, description: "Start DMS after EDW deploy completes.  Do NOT enable if its for a pending Octane update.")
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
        JENKINS_ENVIRONMENT = 'true'

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
        stage("Disable New Jobs") {
            environment {
                AWS_PROFILE = "${params.environment}"
            }
            steps {
                sh "integ/scripts/events-toggle-triggers.sh ${params.environment} disable"
            }
        }
        stage("Purge Pending Jobs") {
            when { equals expected: true, actual: params.clear_pending}
            environment {
                AWS_PROFILE = "${params.environment}"
            }
            steps {
                sh "integ/scripts/clear-sqs.sh ${params.environment}"
            }
        }
        stage("Prepare Deploy") {
            parallel {
                stage("Stop DMS") {
                    steps {
                       build job: 'mt-ops-edw-dms-task-manager',
                           propagate: true,
                           wait: true,
                           parameters: [
                               string(name: 'git_branch', value: params.octane_git_branch),
                               string(name: 'app_env', value: params.octane_environment),
                               string(name: 'action', value: 'stop')
                           ]
                    }
                }
                stage("Build Docker images") {
                    steps {
                        sh "./integ/scripts/s3-artifact-download.sh './docker/pentaho/install' 'pdi-ce-9.0.0.0-423.zip' 'data-warehouse/pdi-ce-9.0.0.0-423.zip'"
                        dir("./docker") {
                            sh "./aws-ecr-login.sh 188213074036"
                            sh "./docker-rebuild.sh"
                        }
                    }
                }
                stage("Stop Running Jobs") {
                    when { equals expected: true, actual: params.stop_jobs}
                    environment {
                        AWS_PROFILE = "${params.environment}"
                    }
                    steps {
                        sh "integ/scripts/step-functions-stop-executions.sh ${params.environment}"
                    }
                }
            }
        }
        stage("Deploy to environment") {
            environment {
                AWS_PROFILE = "${params.environment}"
            }
            steps {
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
                build job: 'bi-ops-data-warehouse-infrastructure-deploy',
                    propagate: true,
                    wait: true,
                    parameters: [
                        string(name: 'git_branch', value: params.git_branch),
                        string(name: 'environment', value: params.environment),
                        booleanParam(name: 'auto_apply', value: true)
                    ]
            }
        }
        stage("Resume Jobs") {
            parallel {
                stage("Enable New Jobs") {
                    environment {
                        AWS_PROFILE = "${params.environment}"
                    }
                    steps {
                        sh "sleep 10"
                        sh "integ/scripts/events-toggle-triggers.sh ${params.environment} enable"
                    }
                }
                stage("Update DMS") {
                    when { equals expected: true, actual: params.start_dms}
                    steps {
                       build job: 'mt-ops-edw-dms-task-manager',
                           propagate: true,
                           wait: true,
                           parameters: [
                               string(name: 'git_branch', value: params.octane_git_branch),
                               string(name: 'app_env', value: params.octane_environment),
                               string(name: 'action', value: "update-and-start")
                           ]
                    }
                }
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

def zoomMessage(status, token, webhook, message = null) {
    wrap([$class: 'BuildUser']) {
        zoomSend(
            authToken: token,
            webhookUrl: webhook,
            message: "${env.JOB_NAME} #${currentBuild.number} for ${params.environment} - ${status}\n" +
                "   Clear Pending ETLs (SQS)? ${params.clear_pending}\n" +
                "   Stop Running ETLs? ${params.stop_jobs}\n" +
                (message == null ? "" : "    ${message}\n") +
                "Submitted by ${env.BUILD_USER} for ${params.git_branch}"
        )
    }
}

def zoom(status) {
    zoomMessage(status, env.ZOOM_TOKEN_STATUS, env.ZOOM_WEBHOOK_STATUS)
}

def zoomAlarm(status, message = null) {
    zoomMessage(status, env.ZOOM_TOKEN_ALARM, env.ZOOM_WEBHOOK_ALARM, message)
}
