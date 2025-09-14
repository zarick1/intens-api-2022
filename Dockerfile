FROM container-registry.oracle.com/java/jdk:8 AS build

ENV MAVEN_VERSION=3.8.8 \
    MAVEN_HOME=/opt/maven \
    PATH=/opt/maven/bin:$PATH

RUN yum -y install curl tar gzip && \
    curl -fsSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -o /tmp/maven.tar.gz && \
    tar -xzf /tmp/maven.tar.gz -C /opt && \
    ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn && \
    yum clean all && rm -rf /var/cache/yum /tmp/*

WORKDIR /app

COPY pom.xml .
RUN mvn -q -e -B -DskipTests dependency:go-offline

COPY src ./src
RUN mvn -q -e -B -DskipTests clean package

FROM container-registry.oracle.com/java/serverjre:8
WORKDIR /app

ENV PORT=8080

COPY --from=build /app/target/*.jar /app/app.jar

ENTRYPOINT ["sh","-c","java -jar /app/app.jar --server.port=${PORT}"]

EXPOSE 8080
