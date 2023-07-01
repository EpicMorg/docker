FROM epicmorg/python:3.10-develop AS build    

WORKDIR /app    

RUN git clone https://github.com/Em1tSan/freegpt-webui-ru.git /app && 
    rm -rfv /app/.git
    
RUN apt-get update && \  
    apt-get install -y --no-install-recommends build-essential libffi-dev cmake libcurl4-openssl-dev && \  
    pip3 install --user --no-cache-dir -r /app/requirements-docker.txt   
    
# Production stage    
FROM epicmorg/python:3.10 AS production    
    
WORKDIR /app    
    
COPY --from=build /root/.local /root/.local

COPY --from=build /app /app

#RUN git clone https://github.com/Em1tSan/freegpt-webui-ru.git /app && 
#    rm -rfv /app/.git
    
ENV PATH=/root/.local/bin:$PATH

EXPOSE 1338
    
CMD ["python3", "./run.py"]
