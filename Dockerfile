FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/my-java-app.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=8081"]
