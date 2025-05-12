pipeline {
    agent any

    environment {
        // Remplacez par votre URL SonarQube par son @IP  
        SONAR_HOST_URL = 'http://192.168.1.148:9000'
    }

    stages {
        
        //Clôner le dépôt depuis Github
        stage('Cloner le dépôt') {
            steps {
                git url: 'https://github.com/MedAmine22/spring-boot-app.git', branch: 'master'
            }
        }

        //Installer les dépendances de votre application avec l'outil de construction de build maven
        stage('Build Maven') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }

        //Effectuer une analyse de la qualité de code avec Sonarqube
        //Créer un projet un projet dans sonarqube
        stage('Analyse SonarQube') {
            steps {
                withSonarQubeEnv('sonar-token') {
                    // Coller le token créé depuis sonarqube project dans la commande de sonar
                    sh 'mvn sonar:sonar -Dsonar.projectKey=bis-sonarqube-project -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=squ_12dc5303a322f735859acd7fab0615ba4c9df7d6'
                }
            }
        }

        //Dockériser l'application et faire en sortir une image de l'application avec docker build
        stage('Docker Build') {
            steps {
                // Specifier un nom pour le build
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
