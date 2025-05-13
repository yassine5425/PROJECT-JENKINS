pipeline {
    agent any

    environment {
        SONAR_HOST_URL = 'http://192.168.50.4:9000'
    }

    stages {
        stage('Check Prerequisites') {
            steps {
                sh 'docker --version' // Check Docker installation
                sh 'docker ps' // Check Docker permissions
                sh 'docker info' // Check Docker daemon
            }
        }

        stage('Clone le dépôt') {
            steps {
                git url: 'https://github.com/yassine5425/PROJECT-JENKINS.git', branch: 'main'
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('Check SonarQube Connectivity') {
            steps {
                sh 'curl -I ${SONAR_HOST_URL}' // Verify SonarQube server is reachable
            }
        }

        stage('Analyse SonarQube') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_AUTH_TOKEN')]) {
                    script {
                        def scannerHome = tool name: 'SonarScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                        sh """
                            ${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=projet-jenkins \
                            -Dsonar.projectName=projet-jenkins \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=${SONAR_HOST_URL} \
                            -Dsonar.login=\${SONAR_AUTH_TOKEN} \
                            -X
                        """
                    }
                }
            }
        }

        stage('Docker Build and Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker build -t app:latest .
                        docker tag app:latest $DOCKER_USERNAME/app:latest
                        docker push $DOCKER_USERNAME/app:latest
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline terminé avec succès.'
        }
        failure {
            echo '❌ Échec du pipeline.'
        }
    }
}
