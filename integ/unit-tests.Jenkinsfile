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
    }
    stages {
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
                    // login to ECR in the jenkins account
                    sh "./aws-ecr-login.sh 188213074036"
                    sh "./docker-rebuild.sh"
                }
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
