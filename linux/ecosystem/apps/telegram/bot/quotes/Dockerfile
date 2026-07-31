FROM docker.io/epicmorg/debian:bookworm-python-3.11

ENV TELEGRAMBOT_DIR=${EMG_LOCAL_BASE_DIR}/telegram/bot/quotes
RUN mkdir -p ${TELEGRAMBOT_DIR}

WORKDIR ${TELEGRAMBOT_DIR}

COPY bot/bot.py ${TELEGRAMBOT_DIR}/bot.py
COPY bot/quotes.txt ${TELEGRAMBOT_DIR}/quotes.txt
COPY bot/requirements.txt ${TELEGRAMBOT_DIR}/requirements.txt
COPY bot/translations.json ${TELEGRAMBOT_DIR}/translations.json

RUN pip install --no-cache-dir -r ${TELEGRAMBOT_DIR}/requirements.txt 

ENTRYPOINT ["python3", "bot.py"]
