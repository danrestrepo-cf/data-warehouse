#! groovy

pipeline {
    agent { label "edw-test" }
    parameters {
        string(name: "git_branch", defaultValue: "", description: "Enter the name of the branch to build. E.g. master")
    }
    options {
        ansiColor("xterm")
        timeout(time: 2, unit: "HOURS")
    }
    environment {
        JENKINS_ENVIRONMENT = 'true'

        FLYWAY_IMAGE='188213074036.dkr.ecr.us-east-1.amazonaws.com/lura/dev-flyway:8'
        POSTGRES_IMAGE='188213074036.dkr.ecr.us-east-1.amazonaws.com/lura/dev-postgres:13'
    }
    stages {
        stage("Prepare Docker") {
            steps {
                sh '''docker stop $(docker ps -a -q) || true'''
                sh '''docker rm $(docker ps -a -q) || true'''
                // login to ECR in the jenkins account
                sh "docker/aws-ecr-login.sh 188213074036"
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
        stage('Install requisite python libraries') {
            steps {
                sh 'pip3 install -r ./python-utilities/requirements.txt'
            }
        }
        stage("Test via Jenkins agent") {
            steps {
                dir("./pentaho/test") {
                    sh "./unit-test-runner.sh 2>&1"
                }
            }
        }
    }
}
