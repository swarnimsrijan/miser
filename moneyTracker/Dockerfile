# Backend image: builds with Gradle, runs on a slim JRE as a non-root user.
FROM eclipse-temurin:21-jdk AS build
WORKDIR /src
COPY gradlew settings.gradle.kts build.gradle.kts ./
COPY gradle gradle
RUN ./gradlew --no-daemon dependencies > /dev/null
COPY src src
RUN ./gradlew --no-daemon bootJar -x test && cp build/libs/*-SNAPSHOT.jar /app.jar

FROM eclipse-temurin:21-jre
RUN useradd --system --uid 10001 miser
USER miser
COPY --from=build /app.jar /app/app.jar
EXPOSE 8080
# server.address defaults to 127.0.0.1; the container sets SERVER_ADDRESS=0.0.0.0
# and publishes no port, so only the reverse proxy on the compose network reaches it.
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75", "-jar", "/app/app.jar"]
