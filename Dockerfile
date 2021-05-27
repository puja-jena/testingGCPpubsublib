# first download all deps, allows for faster builds when only our code changed
FROM gradle:6.6-jdk14 as cache
RUN mkdir -p /home/gradle/cache_home
ENV GRADLE_USER_HOME /home/gradle/cache_home
COPY build.gradle.kts /home/gradle/kotlin-code/
WORKDIR /home/gradle/kotlin-code
RUN gradle clean build -i --stacktrace

# copy in the deps from the above image, and now pull in the code and build that, creating an executable fat jar
FROM gradle:6.6-jdk14 as builder
COPY --from=cache /home/gradle/cache_home /home/gradle/.gradle
COPY . /usr/src/kotlin-code/
WORKDIR /usr/src/kotlin-code
RUN gradle build -i --stacktrace
RUN ls /usr/src/kotlin-code /usr/src/kotlin-code/build/libs

# Slimmed down running env where we only copy in the jar. This is what actually would be run in prod.
FROM openjdk:14-jdk-alpine
COPY --from=builder /usr/src/kotlin-code/build/libs/gcppubsubtest.jar /bin/runner/run.jar
WORKDIR /bin/runner
CMD ["java","-jar","run.jar"]
