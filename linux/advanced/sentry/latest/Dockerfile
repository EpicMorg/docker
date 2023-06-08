FROM sentry
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.vendor="EpicMorg DevTeam, developer@epicm.org"
LABEL org.opencontainers.image.authors="STAM, kasthack, Aleks-Z"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.url="https://github.com/EpicMorg/docker"
LABEL donate.crypto.TON="EQDvHXRK-K1ZieJhgTD9JZQk7xCnWzRbctYnUkWq1lZq1bUg"
LABEL donate.crypto.ETH="0x26a8443a694f08cdfec966aa6fd72c45068753ec"
LABEL donate.crypto.BTC="bc1querz8ug9asjmsuy6yn4a94a2athgprnu7e5zq2"
LABEL donate.crypto.LTC="ltc1qtwwacq8f0n76fer2y83wxu540hddnmf8cdrlvg"
LABEL donate.crypto.NVC="4SbMynYETyhmKdggu8f38ULU6yQKiJPuo6"
LABEL donate.crypto.DOGE="DHyfE1CZzWtyaQiaMmv6g4KvXVQRUgrYE6"
LABEL donate.crypto.PPC="pQWArPzYoLppNe7ew3QPfto1k1eq66BYUB"
LABEL donate.crypto.RVN="R9t2LKeLhDSZBKNgUzSDZAossA3UqNvbV3"
LABEL donate.crypto.ZEC="t1KRMMmwMSZth8vJcd2ZHtPEFKTQ74yVixE"
LABEL donate.crypto.XMR="884PqZ1gDjWW7fKxtbaeRoBeSh9EGZbkqUyLriWmuKbwLZrAJdYUs4wQxoVfEJoW7LBhdQMP9cFhZQpJr6xvg7esHLdCbb1"

RUN rm -rfv /etc/apt/sources.list
RUN rm -rfv /etc/locale.gen

COPY etc/apt/trusted.gpg.d/deb-multimedia-keyring.gpg /etc/apt/trusted.gpg.d/deb-multimedia-keyring.gpg
COPY etc/apt/apt.conf.d/99-no-check-valid-until /etc/apt/apt.conf.d/99-no-check-valid-until
COPY etc/apt/sources.list /etc/apt/sources.list
COPY etc/locale.gen /etc/locale.gen

RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo gcc libsasl2-dev libldap2-dev libssl-dev

RUN pip install sentry-ldap-auth

RUN sudo -i -u sentry pip install sentry-ldap-auth

