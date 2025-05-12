pipeline {
    agent any

    environment {
        // Remplacez par l'IP de votre serveur SonarQube
        SONAR_HOST_URL = 'http://192.168.50.4:9000'
    }

    stages {
        
        // Cloner le dépôt depuis GitHub
        stage('Cloner le dépôt') {
            steps {
                git url: 'https://github.com/MedAmine22/spring-boot-app.git', branch: 'master'
            }
        }

        // Installer les dépendances avec Maven
        stage('Build Maven') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }

        // Analyse de la qualité de code avec SonarQube
        stage('Analyse SonarQube') {
            steps {
                withSonarQubeEnv('sonar-token') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=bis-sonarqube-project -Dsonar.host.url=http://192.168.50.4:9000 -Dsonar.login=squ_12dc5303a322f735859acd7fab0615ba4c9df7d6'

                }
            }
        }

        // Dockeriser l'application
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
