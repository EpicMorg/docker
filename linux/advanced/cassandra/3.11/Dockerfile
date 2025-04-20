FROM bitnami/cassandra:3.11

USER root

ARG CAS_LUCENE_PLUGIN_VER=3.11.3.0
ARG CAS_LUCENE_PLUGIN_URL=https://repo1.maven.org/maven2/com/stratio/cassandra/cassandra-lucene-index-plugin/${CAS_LUCENE_PLUGIN_VER}/cassandra-lucene-index-plugin-${CAS_LUCENE_PLUGIN_VER}.jar

RUN cd /opt/bitnami/cassandra/lib && \
    curl ${CAS_LUCENE_PLUGIN_URL} --output cassandra-lucene-index-plugin-${CAS_LUCENE_PLUGIN_VER}.jar


COPY usr/local/share/ca-certificates /usr/local/share/ca-certificates
RUN update-ca-certificates --fresh

USER 1001
