FROM gradle:6.8.3-jdk11 AS build
WORKDIR /source
RUN git clone https://github.com/lamasurfer/jclo_transfer.git
WORKDIR /source/jclo_transfer
RUN gradle clean build -x test --no-daemon
FROM bellsoft/liberica-openjdk-alpine
EXPOSE 8080
COPY --from=build /source/jclo_transfer/build/libs/*.jar /transfer.jar
ENTRYPOINT ["java","-jar","/transfer.jar"]