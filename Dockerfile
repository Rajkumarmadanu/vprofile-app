FROM maven:3.9.9-eclipse-temurin-21-jammy AS BUILD_IMAGE

# Set the working directory
WORKDIR /app

# Copy the local source code into the container
COPY ./ /app

# Build the project using Maven
RUN mvn clean install -DskipTests

# Use a lightweight Tomcat image for the final build
# and copy the built WAR file into it
FROM tomcat:10-jdk21

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=BUILD_IMAGE /app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
