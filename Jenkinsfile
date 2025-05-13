pipeline {
    agent any

    environment {
        SONAR_HOST_URL = 'http://192.168.50.4:9000'  // URL de ton serveur SonarQube
    }

    stages {
        stage('Check Prerequisites') {
            steps {
                script {
                    // Vérifier si Docker est installé et si le daemon Docker fonctionne
                    sh 'docker --version'   // Vérifier l'installation de Docker
                    sh 'docker ps'          // Vérifier les permissions Docker
                    sh 'docker info'        // Vérifier si le daemon Docker fonctionne correctement
                }
            }
        }

        stage('Clone le dépôt') {
            steps {
                script {
                    // Cloner le dépôt Git à partir de la branche 'main'
                    git url: 'https://<ton-dépôt-git-url>', branch: 'main'
                }
            }
        }

        stage('Build Maven') {
            steps {
                script {
                    // Construire le projet Maven sans exécuter les tests
                    sh 'mvn clean install -DskipTests'
                }
            }
        }

        stage('Check SonarQube Connectivity') {
            steps {
                script {
                    // Vérifier si SonarQube est joignable
                    sh 'curl -I ${SONAR_HOST_URL}'
                }
            }
        }

        stage('Analyse SonarQube') {
            steps {
                script {
                    // Vérifier la version du scanner SonarQube
                    timeout(time: 5, unit: 'MINUTES') {
                        withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_AUTH_TOKEN')]) {
                            def scannerHome = tool name: 'SonarScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                            sh """
                                echo "Workspace contents:"
                                ls -la
                                echo "SonarQube Scanner Version:"
                                ${scannerHome}/bin/sonar-scanner --version
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
        }

        stage('Docker Build and Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        // Login au registre Docker, puis construction et push de l'image
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
