#! groovy

pipeline {
    agent { label "data-warehouse-infrastructure" }
    parameters {
        string(name: "git_branch", defaultValue: "", description: "Enter the name of the branch to build. E.g. master")
        choice(name: "environment", description: "Choose which environment to run on.",
            choices: ["qa", "prod"]
        )
        booleanParam(name: 'auto_apply', description: 'Skip the user prompt and apply.', defaultValue: false)
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
        ZOOM_TOKEN_ALARM = credentials('zoom-token-bi-alarms')
        ZOOM_WEBHOOK_ALARM = credentials('zoom-webhook-bi-alarms')
    }
    stages {
        stage('Notify') {
            steps {
                zoom('STARTED')
            }
        }
        stage("Plan") {
            when {
                equals expected: false, actual: params.auto_apply
            }
            steps {
                dir("infrastructure") {
                    sh "terraform init"
                    // try to create the workspace, but it may already exist so ignore the failure
                    sh "terraform workspace new ${params.environment} || true"
                    sh "terraform workspace select ${params.environment}"
                    sh "terraform plan"
                }
            }
        }
        stage("Prompt") {
            when {
                equals expected: false, actual: params.auto_apply
            }
            options {
                timeout(time: 1, unit: 'HOURS')
            }
            steps {
                input message: "Is the above plan correct?", ok: 'Yes.'
                echo "Proceeding."
            }
        }
        stage("Apply") {
            steps {
                dir("infrastructure") {
                    sh "terraform init"
                    // try to create the workspace, but it may already exist so ignore the failure
                    sh "terraform workspace new ${params.environment} || true"
                    sh "terraform workspace select ${params.environment}"
                    sh "terraform apply -auto-approve"
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
