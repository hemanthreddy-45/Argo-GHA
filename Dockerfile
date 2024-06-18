# Stage 1: Build the application with Maven
FROM maven:3.5.2-jdk-8-alpine AS MAVEN_TOOL_CHAIN
WORKDIR /app
COPY pom.xml .
RUN mvn -B dependency:go-offline
# Copy the source code and build the application
COPY src /app/src/
RUN mvn -B package
# Stage 2: Run the application with Java
FROM openjdk:8-jre-alpine
# Expose port 8080 for the Spring Boot application
EXPOSE 8080
# Create a directory for the application
RUN mkdir /app
# Copy the built JAR file from the previous stage
COPY --from=MAVEN_TOOL_CHAIN /app/target/*.jar /app/spring-boot-application.jar
# Set the command to run the Spring Boot application
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/spring-boot-application.jar"]
# Optional: Add a health check to verify the application's health
HEALTHCHECK --interval=1m --timeout=3s CMD wget -q -T 3 -s http://localhost:8080/actuator/health || exit 1







