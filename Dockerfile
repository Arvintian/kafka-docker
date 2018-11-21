FROM anapsix/alpine-java

ARG kafka_version
ARG scala_version

ENV KAFKA_VERSION=$kafka_version \
    SCALA_VERSION=$scala_version \
    KAFKA_HOME=/opt/kafka \
    PATH=${PATH}:${KAFKA_HOME}/bin

COPY download-kafka.sh start-kafka.sh /tmp/

RUN apk add --update unzip wget curl jq coreutils \
    && chmod a+x /tmp/*.sh \
    && mv /tmp/start-kafka.sh  /usr/bin \
    && /tmp/download-kafka.sh \
    && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
    && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
    && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka \
    && rm /tmp/*

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]
