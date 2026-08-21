# Stage 1: Build the application using a valid Java 11 image
FROM eclipse-temurin:11-jdk AS BUILD_IMAGE
RUN apt update && apt install maven -y
COPY ./ /vprofile-project
RUN cd /vprofile-project && mvn clean install 

# Stage 2: Deploy to Tomcat using a valid Java 11 production image
FROM tomcat:9.0-jre11-temurin
LABEL "Project"="Vprofile"
LABEL "Author"="Imran"

RUN rm -rf /usr/local/tomcat/webapps/*
# Fixed paths with leading slashes to prevent directory resolution bugs
COPY --from=BUILD_IMAGE /vprofile-project/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
