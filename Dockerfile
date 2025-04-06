# Step 1: Build the app using Maven
FROM maven:3.8.1-jdk-11 as builder

WORKDIR /app
COPY . /app
RUN mvn clean install

# Step 2: Run the app in a lightweight container
FROM openjdk:11-jre-slim

WORKDIR /app
COPY --from=builder /app/target/*.jar /app/*.jar

CMD ["java", "-jar", "/app/*.jar"]
