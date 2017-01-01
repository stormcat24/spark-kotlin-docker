FROM java:openjdk-8-jdk-alpine

COPY . /spark-kotlin-docker

RUN apk update && \ 
    apk add --virtual build-dependencies build-base bash curl && \
    cd /spark-kotlin-docker && ./gradlew clean && \
    cd /spark-kotlin-docker && ./gradlew build && \
    mkdir -p /usr/local/spark-kotlin-docker/lib && \
    cp -R /spark-kotlin-docker/build/libs/* /usr/local/spark-kotlin-docker/lib/ && \
    curl -o /usr/local/spark-kotlin-docker/lib/jolokia-jvm-agent.jar https://repo1.maven.org/maven2/org/jolokia/jolokia-jvm/1.3.5/jolokia-jvm-1.3.5-agent.jar && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    rm -rf ~/.gradle && \
    rm -rf /spark-kotlin-docker

ENTRYPOINT java $JAVA_OPTS -javaagent:/usr/local/spark-kotlin-docker/lib/jolokia-jvm-agent.jar=port=8778,host=0.0.0.0 -jar /usr/local/spark-kotlin-docker/lib/spark-kotlin-docker.jar

EXPOSE 4567 8778 
