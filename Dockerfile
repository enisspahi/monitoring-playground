FROM docker.io/eclipse-temurin:21-jre-alpine

EXPOSE 8080
EXPOSE 5000

RUN mkdir /app
COPY build/libs/*.jar /app/application.jar
WORKDIR /app

# create a nonroot user and group
RUN addgroup -S javauser && adduser -S -s /bin/false -G javauser javauser
RUN chown -R javauser:javauser /app
USER javauser

# run the application
CMD "java" "-jar" "application.jar"