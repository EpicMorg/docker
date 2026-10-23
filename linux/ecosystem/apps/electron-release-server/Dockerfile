FROM ghcr.io/epicmorg/nodejs:19
LABEL org.opencontainers.image.title="EpicMorg Electron Release Server"
LABEL org.opencontainers.image.description="Electron Release Server - update and download server for Electron apps"

RUN git clone https://github.com/ArekSredzki/electron-release-server.git /usr/src/electron-release-server

WORKDIR /usr/src/electron-release-server

RUN npm install \
  && ./node_modules/.bin/bower install --allow-root \
  && npm cache clean --force \
  && npm prune --production

# Bundle app source
RUN cp -rfv /usr/src/electron-release-server/config/docker.js /usr/src/electron-release-server/config/local.js

#healthcheck. good practice
HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:80/ || exit 1

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

#Final config
EXPOSE 80 5000

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
