```groovy
pipeline {
    agent any

    environment {
        SONAR_HOST_URL = 'http://192.168.50.4:9000'
    }

    stages {
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

        stage('Analyse SonarQube') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_AUTH_TOKEN')]) {
                    withSonarQubeEnv('sonarqube') {
                        script {
                            def scannerHome = tool 'SonarScanner'
                            // Use environment variable to avoid string interpolation of secrets
                            withEnv(["SONAR_TOKEN=${SONAR_AUTH_TOKEN}"]) {
                                sh """
                                    ${scannerHome}/bin/sonar-scanner \
                                    -Dsonar.projectKey=projet-jenkins \
                                    -Dsonar.sources=. \
                                    -Dsonar.host.url=${SONAR_HOST_URL} \
                                    -Dsonar.login=\${SONAR_TOKEN}
                                """
                            }
                        }
                    }
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t app:latest .'
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
```
