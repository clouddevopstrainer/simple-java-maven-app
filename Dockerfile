# Use an official OpenJDK base image
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the application source code into the container
COPY . .

# Build the application using Maven
RUN mvn -B -DskipTests clean package --no-transfer-progress

# Use a minimal JDK runtime image for deployment
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8081

# Run the application
CMD ["java", "-jar", "app.jar"]

