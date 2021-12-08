#! groovy

pipeline {
    agent { label 'edw-test' }
    parameters {
        string(name: 'octane_git_branch', defaultValue: '', description: 'Enter the octane branch id to build. E.g. v2021.1.1.0-release.')
        string(name: 'edw_git_branch', defaultValue: '', description: 'Enter the data-warehouse branch id to build. E.g. v2021.1.1.0-release.')
        choice(
                name: 'env_file',
                choices: ['/var/taggartsoftware/jenkins/junit-2021.2.lura.env'],
                description: 'Do not change. Only used programmatically.'
        )
        booleanParam(
                name: 'run_environment_loader',
                defaultValue: false,
                description: 'If checked will run the full environment loader, else uses a snapshot.'
        )
    }
    options {
        ansiColor('xterm')
        timeout(time: 2, unit: 'HOURS')
    }
    environment {
        DB_ENV_LOADER = 'DashboardAccountEnvironmentLoader'
        JENKINS_ENVIRONMENT = 'true'

        FLYWAY_IMAGE='188213074036.dkr.ecr.us-east-1.amazonaws.com/lura/dev-flyway:6'
        POSTGRES_IMAGE='188213074036.dkr.ecr.us-east-1.amazonaws.com/lura/dev-postgres:12'

        // Zoom notifications:
        ZOOM_TOKEN_STATUS = credentials('zoom-token-bi-jenkins')
        ZOOM_WEBHOOK_STATUS = credentials('zoom-webhook-bi-jenkins')
        // Output path for file containing SQL statements to update EDW config.mdi data in accordance with Octane
        CONFIG_METADATA_MAINTENANCE_FILENAME = 'config_mdi_metadata_maintenance.sql'
    }
    stages {
        stage('Notify') {
            steps {
                zoom('STARTED')
            }
        }
        stage('Install requisite python libraries') {
            steps {
                sh 'pip3 install -r ./python-utilities/requirements.txt'
            }
        }
        stage('Prepare Docker') {
            steps {
                sh '''docker stop $(docker ps -a -q) || true'''
                sh '''docker rm $(docker ps -a -q) || true'''
            }
        }
        stage('Build EDW') {
            steps {
                sh "./integ/scripts/s3-artifact-download.sh './docker/pentaho/install' 'pdi-ce-9.0.0.0-423.zip' 'data-warehouse/pdi-ce-9.0.0.0-423.zip'"
                dir('./docker') {
                    // login to ECR in the jenkins account
                    sh "./aws-ecr-login.sh 188213074036"
                    sh './docker-rebuild.sh'
                }
            }
        }
        stage('Build Octane database') {
            steps {
                withEnv(readFile(params.env_file).split('\n').findAll { !it.startsWith('#') } as List) {
                    dir('octane') {
                        checkout([$class: 'GitSCM',
                                branches: [[name: "${octane_git_branch}"]],
                                doGenerateSubmoduleConfigurations: false,
                                extensions: [[$class: 'CloneOption', timeout: 10, noTags: false, shallow: true]],
                                submoduleCfg: [],
                                userRemoteConfigs: [[url: 'git@github.com:mofnong/octane.git']]])

                        sh 'cp src/main/resources/dev_sample_logback.groovy src/main/resources/logback.groovy'

                        sh './gradlew clean'
                        sh './gradlew -Pcompose=jenkins-no-edw aws-get-login dockerComposeUp'
                        // Give Docker time to bring the database up
                        sh 'sleep 30'
                        script {
                            if (params.octane_git_branch != 'prod_release' || params.run_environment_loader) {
                                sh "./gradlew -Pcompose=jenkins-no-edw aws-get-login runEnvLoader --args ${env.DB_ENV_LOADER}"
                            } else {
                                sh 'scripts/pull-and-run-db-restore-and-migration-all.sh'
                            }
                        }
                    }
                }
            }
        }
        stage('Run EDW metadata maintenance') {
            steps {
                sh "./edw-metadata-maintenance.sh ${env.CONFIG_METADATA_MAINTENANCE_FILENAME}"
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: "**/metadata/**/*.yaml, **/${env.CONFIG_METADATA_MAINTENANCE_FILENAME}"
            zoom(currentBuild.currentResult)
            cleanWs()
        }
        unsuccessful {
            zoom(currentBuild.currentResult)
        }
    }
}

def zoom(status) {
    wrap([$class: 'BuildUser']) {
        zoomSend(
                authToken: env.ZOOM_TOKEN_STATUS,
                webhookUrl: env.ZOOM_WEBHOOK_STATUS,
                message: "${env.JOB_NAME} #${currentBuild.number} - ${status}\n" +
                        "Submitted by ${env.BUILD_USER} for:\n" +
                        "    Octane ${params.octane_git_branch}\n" +
                        "    EDW ${params.edw_git_branch}"
        )
    }
}
