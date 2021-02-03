FROM adoptopenjdk/openjdk11
ARG JAR_FILE=output/libs/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar", "-Dspring.profiles.active=mysql"]
