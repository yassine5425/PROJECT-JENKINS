pipeline {
    agent any

    environment {
        SONAR_HOST_URL = 'http://192.168.50.4:9000'
        SONAR_TOKEN = credentials('projet') // Ton ID de token Jenkins
    }

    stages {

        stage('Cloner le dépôt') {
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
                withSonarQubeEnv('SonarQubeScanner') {
                    sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=bis-sonarqube-project \
                        -Dsonar.host.url=$SONAR_HOST_URL \
                        -Dsonar.login=$SONAR_TOKEN
                    """
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
