FROM ghcr.io/epicmorg/nodejs:23
LABEL org.opencontainers.image.title="EpicMorg vk2discord"
LABEL org.opencontainers.image.description="VK2Discord - reposts VK community and user wall posts to Discord via webhooks"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Installing vk2discord
##################################################################
WORKDIR /usr/src/vk2discord

RUN git clone https://github.com/MrZillaGold/VK2Discord.git /usr/src/vk2discord

RUN npm config set engine-strict false && \
    npm install

##################################################################
#                   cleaninig up
##################################################################
RUN apt-get clean -y && \
    apt-get clean all -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/vk2discord/* && \
    rm -rfv /var/cache/apt/archives/*.deb

CMD ["npm", "start"]
