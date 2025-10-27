##################################################################
#                   Test official Mattermost image
##################################################################
FROM docker.io/mattermost/mattermost-enterprise-edition:release-10.9 AS bootstrap
RUN ["/mattermost/bin/mattermost", "version"]

##################################################################
#                   Patch official Mattermost image
##################################################################
FROM epicmorg/debian:trixie-python-2.7 AS edit

WORKDIR /tmp

COPY edit.py2 /tmp/edit.py
COPY --from=bootstrap /mattermost/bin/mattermost /tmp/mattermost

RUN chmod +x /tmp/edit.py && \
    /tmp/edit.py

##################################################################
#                   Installing Mattermost
##################################################################
FROM docker.io/epicmorg/debian:trixie

# Set build arguments
ARG PUID=2000
ARG PGID=2000

# Create MM User and Group
RUN groupadd -g ${PGID} mattermost && \
    useradd -u ${PUID} -g mattermost -m -d /mattermost mattermost && \
    mkdir -p /mattermost/data /mattermost/logs /mattermost/plugins /mattermost/client/plugins /mattermost/config && \
    chown -R mattermost:mattermost /mattermost

# Install Mattermost
COPY --from=bootstrap --chown=mattermost:mattermost /mattermost /mattermost
RUN rm -rfv /mattermost/bin/mattermost
COPY --from=edit --chown=mattermost:mattermost /tmp/mattermost /mattermost/bin/
RUN chmod +x /mattermost/bin/mattermost 

# Set environment variables
ENV PATH="/mattermost/bin:${PATH}"
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
ENV MM_SERVICESETTINGS_ENABLELOCALMODE=true

# Setup Mattermost settings
EXPOSE 8065 8067 8074 8075

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s \
    CMD ["/mattermost/bin/mmctl", "system", "status", "--local"]

USER mattermost
WORKDIR /mattermost

# Just check is working
RUN ["/mattermost/bin/mattermost", "version"]

# Declare volumes for mount point directories
VOLUME ["/mattermost/data", "/mattermost/logs", "/mattermost/config", "/mattermost/plugins", "/mattermost/client/plugins"]

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/mattermost/bin/mattermost"]
