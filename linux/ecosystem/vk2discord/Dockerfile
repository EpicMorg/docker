FROM epicmorg/devel AS builder
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp

RUN git clone https://github.com/MrZillaGold/VK2Discord.git vk2discord

FROM epicmorg/edge
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Node.js 16.x
##################################################################
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
    echo "deb https://nightly.yarnpkg.com/debian/ nightly main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y nodejs yarn

##################################################################
#                   Installing vk2discord
##################################################################

WORKDIR /usr/src/vk2discord


COPY --from=builder /tmp/vk2discord/package*.json /usr/src/vk2discord/

RUN npm install -g

COPY --from=builder /tmp/vk2discord/* /usr/src/vk2discord/

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb

CMD npm start
