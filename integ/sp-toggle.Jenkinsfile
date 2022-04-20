#! groovy

pipeline {
    agent { label "dev-data-warehouse-deploy-agent" }
    parameters {
        string(name: "git_branch", defaultValue: "", description: "Enter the name of the branch to build. E.g. master")
        choice(name: "environment", description: "Choose which environment to run on.", choices: ["qa", "prod"])
        booleanParam(name: "disable_edw_triggers", defaultValue: false, description: "Disable event triggers.")
        booleanParam(name: "clear_pending_sqs_queue", defaultValue: false, description: "Purge the SQS queues.")
        booleanParam(name: "stop_jobs", defaultValue: false, description: "Stop running Step Functions.")
        booleanParam(name: "enable_edw_triggers", defaultValue: false, description: "Enable event triggers.")
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
        // for Zoom chat notifications
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
        stage("Prepare AWS CLI") {
            environment {
                AWS_PROFILE = "${params.environment}"
            }
            steps {
                sh "(mkdir ~/.aws) || true"
                sh "mv ./integ/aws-cli-config/deploy.config ~/.aws/config"
            }
        }
        stage("Disable EDW Triggers") {
            when { equals expected: true, actual: params.disable_edw_triggers}
            environment {
                AWS_PROFILE = "${params.environment}"
            }
            steps {
                // sh "integ/scripts/events-toggle-triggers.sh ${params.environment} disable"
                echo "Disable EDW Triggers for environment ${params.environment}"
            }
        }
        stage("Clear Pending SP SQS Queue") {
            when { equals expected: true, actual: params.clear_pending_sqs_queue}
            environment {
                AWS_PROFILE = "${params.environment}"
            }
            steps {
                // sh "integ/scripts/clear-sqs.sh ${params.environment}"
                echo "Clear Pending SP SQS Queue for environment ${params.environment}"
            }
        }
        stage("Stop All Running SPs") {
            when { equals expected: true, actual: params.stop_jobs}
            environment {
                AWS_PROFILE = "${params.environment}"
            }
            steps {
                // sh "integ/scripts/step-functions-stop-executions.sh ${params.environment}"
                echo "Stop Jobs for environment ${params.environment}"
            }
        }
        stage("Notify to Kill PostgreSQL Connections and ECS Containers") {
            when { equals expected: true, actual: params.stop_jobs}
            steps {
                zoomAlarm("PAUSED","!!! Waiting for infrastructure to kill PostgreSQL connections and ECS containers. Resuming after manual approval https://jenkins.taggartsoftware.com/view/Operations%20-%20BI/job/${env.JOB_NAME}/${currentBuild.number}/consoleFull !!!")
            }
        }
        stage("Prompt to continue") {
            when { equals expected: true, actual: params.stop_jobs}
            agent none
            options {
                timeout(time: 8, unit: 'HOURS')
            }
            steps {
                input message: "Has the infrastructure team killed PostgreSQL connections and ECS containers?", ok: 'Yes.'
                echo "Proceeding."
            }
        }
        stage("Enable EDW Triggers") {
            when { equals expected: true, actual: params.enable_edw_triggers}
            environment {
                AWS_PROFILE = "${params.environment}"
            }
            steps {
                sh "sleep 10"
                // sh "integ/scripts/events-toggle-triggers.sh ${params.environment} enable"
                echo "Enable EDW Triggers for environment ${params.environment}"
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
                "   disable_edw_triggers: ${params.disable_edw_triggers}\n" +
                "   clear_pending_sqs_queue: ${params.clear_pending_sqs_queue}\n" +
                "   stop_jobs: ${params.stop_jobs}\n" +
                "   enable_edw_triggers: ${params.enable_edw_triggers}\n" +
                (message == null ? "" : "    ${message}\n") +
                "Submitted by ${env.BUILD_USER}"
        )
    }
}

def zoom(status) {
    zoomMessage(status, env.ZOOM_TOKEN_STATUS, env.ZOOM_WEBHOOK_STATUS)
}

def zoomAlarm(status, message = null) {
    zoomMessage(status, env.ZOOM_TOKEN_ALARM, env.ZOOM_WEBHOOK_ALARM, message)
}
