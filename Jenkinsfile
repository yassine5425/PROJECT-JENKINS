
pipeline {
    agent any

    environment {
        SONAR_HOST_URL = 'http://192.168.50.4:9000'
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git url: 'https://github.com/yassine5425/PROJECT-JENKINS', branch: 'main'
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
                    sh 'mvn sonar:sonar -Dsonar.projectKey=projet-jenkins -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_AUTH_TOKEN'
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
            echo 'Pipeline terminé avec succès.'
        }
        failure {
            echo 'Échec du pipeline.'
        }
    }
}

