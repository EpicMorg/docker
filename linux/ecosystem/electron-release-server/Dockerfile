FROM epicmorg/edge as bootstrap
RUN cd /tmp && \
    git clone https://github.com/ArekSredzki/electron-release-server.git && \
    tree

FROM node:10
# Create app directory
RUN mkdir - p  /usr/src/electron-release-server
WORKDIR /usr/src/electron-release-server

# Install app dependencies
COPY --from=bootstrap /tmp/electron-release-server/package.json  /usr/src/electron-release-server/
COPY --from=bootstrap /tmp/electron-release-server/.bowerrc      /usr/src/electron-release-server/
COPY --from=bootstrap /tmp/electron-release-server/bower.json    /usr/src/electron-release-server/

RUN npm install \
  && ./node_modules/.bin/bower install --allow-root \
  && npm cache clean --force \
  && npm prune --production

# Bundle app source
COPY --from=bootstrap /tmp/electron-release-server/ /usr/src/electron-release-server
COPY --from=bootstrap /tmp/electron-release-server/config/docker.js /usr/src/electron-release-server/config/local.js

EXPOSE 80

CMD [ "npm", "start" ]