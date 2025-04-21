FROM bitnami/cassandra:3.11

USER root

ARG CAS_LUCENE_PLUGIN_VER=3.11.3.0
ARG CAS_LUCENE_PLUGIN_URL=https://repo1.maven.org/maven2/com/stratio/cassandra/cassandra-lucene-index-plugin/${CAS_LUCENE_PLUGIN_VER}/cassandra-lucene-index-plugin-${CAS_LUCENE_PLUGIN_VER}.jar

RUN cd /opt/bitnami/cassandra/lib && \
    curl ${CAS_LUCENE_PLUGIN_URL} --output cassandra-lucene-index-plugin-${CAS_LUCENE_PLUGIN_VER}.jar

##################################################################
#                   Update JavaCA
##################################################################
COPY usr/local/share/ca-certificates /usr/local/share/ca-certificates
RUN update-ca-certificates --fresh && \
    for cert in /usr/local/share/ca-certificates/*.crt; do \
        alias=$(basename "$cert" .crt); \
        keytool -importcert \
            -keystore "$JAVA_HOME/lib/security/cacerts" \
            -storepass changeit \
            -file "$cert" \
            -alias "$alias" \
            -noprompt; \
    done

USER 1001
