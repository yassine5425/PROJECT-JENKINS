# Étape 1 : Utiliser une image de base
FROM maven:3.8.1-jdk-11 AS build

# Étape 2 : Définir le répertoire de travail
WORKDIR /app

# Étape 3 : Copier le fichier pom.xml pour la gestion des dépendances
COPY pom.xml .

# Étape 4 : Télécharger les dépendances avec Maven (et les stocker dans le cache pour éviter de les retélécharger à chaque fois)
RUN mvn dependency:go-offline

# Étape 5 : Copier le code source de l'application
COPY src /app/src

# Étape 6 : Construire l'application avec Maven
RUN mvn clean install -DskipTests

# Étape 7 : Utiliser une image plus légère pour exécuter l'application
FROM openjdk:11-jre-slim

# Étape 8 : Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Étape 9 : Copier le fichier JAR généré dans l'étape précédente
COPY --from=build /app/target/my-app.jar /app/my-app.jar

# Étape 10 : Exposer le port que l'application utilise
EXPOSE 8080

# Étape 11 : Définir la commande d'exécution de l'application
CMD ["java", "-jar", "my-app.jar"]
