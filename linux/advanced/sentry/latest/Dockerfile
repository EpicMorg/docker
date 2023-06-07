FROM sentry

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

