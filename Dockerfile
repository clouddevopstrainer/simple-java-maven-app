# Step 1: Build the app using Maven
FROM maven:3.8.1-jdk-11 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Run the Maven build
RUN mvn clean install -DskipTests

# Step 2: Run the app in a lightweight container
FROM openjdk:11-jre-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the built JAR file from the builder stage into the current container
COPY --from=builder /app/target/*.jar /app/app.jar

# Command to run the application
CMD ["java", "-jar", "/app/app.jar"]
