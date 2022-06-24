FROM epicmorg/nodejs:node17
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Installing vk2discord
##################################################################
WORKDIR /usr/src/vk2discord

RUN git clone https://github.com/MrZillaGold/VK2Discord.git /tmp/vk2discord

RUN cp -rvf /tmp/vk2discord/package*.json /usr/src/vk2discord/

RUN npm config set engine-strict false && \
    npm install -g

RUN cp -rfv /tmp/vk2discord/* /usr/src/vk2discord/

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/vk2discord/* && \
    rm -rfv /var/cache/apt/archives/*.deb

CMD npm start
