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
ENV FREEGTP_PY_BIN=/root/.local/bin
ENV PATH=/root/.local/bin:$PATH

RUN git clone --depth 1 --branch ${FREEGPT_VERSION} https://github.com/Em1tSan/freegpt-webui-ru.git ${FREEGPT_PATH} && \
    rm -rfv ${FREEGPT_PATH}/.git
    
RUN apt-get update && \  
    apt-get install -y --no-install-recommends \
      build-essential \
      libffi-dev cmake \
      libcurl4-openssl-dev && \  
    pip3 install --user --no-cache-dir -r ${FREEGPT_PATH}/requirements.txt  

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
ENV FREEGTP_PY_BIN=/root/.local/bin
ENV PATH=/root/.local/bin:$PATH

RUN mkdir -p ${FREEGTP_PY_BIN} ${FREEGPT_PATH}

##################################################################
#                   Copy bins
##################################################################
COPY --from=build /root/.local /root/.local
COPY --from=build /app /app

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*

WORKDIR ${FREEGPT_PATH}   
EXPOSE  ${FREEGPT_PORT}  

CMD ["python3", "./run.py"]
