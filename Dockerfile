FROM maven:slim AS build

WORKDIR /root/
COPY . /root/

RUN mvn install

FROM openjdk:jdk-slim AS release

RUN adduser --home /home/app --shell /bin/bash --uid 1001 --disabled-password app
USER app
WORKDIR /home/app

ENV SPRING_DATASOURCE_URL jdbc:mysql://127.0.0.1:3306/test

ARG BUILD_DATE
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="Sample Spring Boot App" \
    org.label-schema.description="App which uses spring boot to connect to MySQL" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="0.1"

COPY --from=build /root/target/users-mysql.jar .
ENTRYPOINT ["java", "-jar", "users-mysql.jar"]

EXPOSE 8086


