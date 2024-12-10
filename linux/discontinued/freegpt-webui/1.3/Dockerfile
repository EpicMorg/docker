##################################################################
##################################################################
##################################################################
#                     Build stage   
##################################################################
##################################################################
##################################################################
FROM epicmorg/python:3.10-develop AS build    

ARG FREEGPT_VERSION=1.3

ENV FREEGPT_PATH=/app
ENV FREEGPT_PORT=1338
ENV FREEGPT_ENDPOINT_PORT=1337

RUN git clone --depth 1 --branch ${FREEGPT_VERSION} https://github.com/Em1tSan/freegpt-webui-ru.git ${FREEGPT_PATH} && \
    rm -rfv ${FREEGPT_PATH}/.git
    
RUN apt-get update && \  
    apt-get install -y --no-install-recommends \
      build-essential \
      libffi-dev cmake \
      libcurl4-openssl-dev && \  
    pip3 install --user --no-cache-dir -r ${FREEGPT_PATH}/requirements.txt  

RUN find ${FREEGPT_PATH} -type f -exec dos2unix -k -s -o {} ';'

##################################################################
##################################################################
##################################################################
#                     Production stage   
##################################################################
##################################################################
##################################################################
FROM epicmorg/python:3.10 AS production    

ENV FREEGPT_PATH=/app
ENV FREEGPT_PORT=1338
ENV FREEGPT_ENDPOINT_PORT=1337

RUN mkdir -p ${FREEGPT_PATH}

##################################################################
#                   Setup supervisord
##################################################################
RUN apt-get update && \
    apt-get install -y \
      supervisor

COPY etc/supervisor/conf.d/freegpt.conf /etc/supervisor/conf.d/freegpt.conf

##################################################################
#                   Copy bins
##################################################################
COPY --from=build /root/.local /usr/local
COPY --from=build /app ${FREEGPT_PATH}

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/* && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

WORKDIR ${FREEGPT_PATH}   
EXPOSE  ${FREEGPT_PORT} ${FREEGPT_ENDPOINT_PORT}

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/freegpt.conf"]
