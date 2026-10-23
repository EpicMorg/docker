FROM ghcr.io/epicmorg/debian:trixie
LABEL org.opencontainers.image.title="EpicMorg Telegram bots"
LABEL org.opencontainers.image.description="Telegram bot that replies with random quotes from a text file (python-telegram-bot)"
#FROM ghcr.io/epicmorg/python:3.13
#FROM ghcr.io/epicmorg/python:3.11

ENV TELEGRAMBOT_DIR=${EMG_LOCAL_BASE_DIR}/telegram/bot/quotes
RUN mkdir -p ${TELEGRAMBOT_DIR}

WORKDIR ${TELEGRAMBOT_DIR}

COPY bot/bot.py ${TELEGRAMBOT_DIR}/bot.py
COPY bot/quotes.txt ${TELEGRAMBOT_DIR}/quotes.txt
COPY bot/requirements.txt ${TELEGRAMBOT_DIR}/requirements.txt
COPY bot/translations.json ${TELEGRAMBOT_DIR}/translations.json

RUN pip install --no-cache-dir --break-system-packages -r ${TELEGRAMBOT_DIR}/requirements.txt 

ENTRYPOINT ["python3", "bot.py"]
