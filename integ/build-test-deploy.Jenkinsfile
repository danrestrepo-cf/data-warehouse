#! groovy

pipeline {
    agent { label "dev-data-warehouse-deploy-agent" }
    parameters {
        string(name: "git_branch", defaultValue: "", description: "Enter the name of the branch to build. E.g. master")
        choice(name: "environment", choices: ["qa", "prod"], description: "Choose which environment to run on.")
    }
    options {
        ansiColor("xterm")
        timeout(time: 3, unit: "HOURS")
    }
    stages {
        stage("Test via Jenkins agent") {
            steps {
                build job: 'bi-dev-edw-unit-tests',
                        parameters: [string(name: 'git_branch', value: "${params.git_branch}")],
                        propagate: true,
                        wait: true
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
                sh "./integ/s3-artifact-download.sh './docker/pentaho/install' 'pdi-ce-9.0.0.0-423.zip' 'data-warehouse/pdi-ce-9.0.0.0-423.zip'"
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
                dir("./docker") {
                    sh "./run-migration.sh ${params.environment}"
                    sh "./push-image.sh ${params.environment} pentaho"
                    sh "./push-image.sh ${params.environment} etl"
                }
            }
        }
    }
}
