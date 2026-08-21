# ============================================================
# Multi-stage Dockerfile for Remote Exam Result Management System
# ============================================================

# Stage 1: Build all Maven modules
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY common/pom.xml common/
COPY rmi-server/pom.xml rmi-server/
COPY web-app/pom.xml web-app/
RUN mvn dependency:go-offline -B
COPY common/src common/src
COPY rmi-server/src rmi-server/src
COPY web-app/src web-app/src
RUN mvn clean package -DskipTests -B

# Stage 2: RMI Server runtime
FROM eclipse-temurin:17-jre AS rmi-server
WORKDIR /app
RUN mkdir -p data
COPY --from=build /app/rmi-server/target/rmi-server-1.0.0.jar app/rmi-server.jar
COPY --from=build /app/rmi-server/target/libs/ app/libs/
ENTRYPOINT ["java", "-jar", "app/rmi-server.jar"]

# Stage 3: Web App runtime
FROM eclipse-temurin:17-jre AS web-app
WORKDIR /app
RUN mkdir -p data src/main/webapp
COPY --from=build /app/web-app/target/remote-exam-result-management-system/ src/main/webapp/
ENV RMI_HOST=rmi-server
ENV RMI_PORT=1099
EXPOSE 8080
ENTRYPOINT ["java", "-cp", "src/main/webapp/WEB-INF/classes:src/main/webapp/WEB-INF/lib/*", "web.WebRunner"]
