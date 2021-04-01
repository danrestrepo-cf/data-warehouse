#! groovy

pipeline {
    agent { label "dev-data-warehouse-deploy-agent" }
    parameters {
        string(name: "git_branch", defaultValue: "", description: "Enter the name of the branch to build. E.g. master")
    }
    options {
        ansiColor("xterm")
        timeout(time: 2, unit: "HOURS")
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
                sh "./integ/s3-artifact-download.sh './docker/pentaho/install' 'pdi-ce-9.0.0.0-423.zip' 'data-warehouse/pdi-ce-9.0.0.0-423.zip'"
                dir("./docker") {
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
