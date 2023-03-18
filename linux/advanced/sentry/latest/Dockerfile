FROM sentry

RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo gcc libsasl2-dev libldap2-dev libssl-dev

RUN pip install sentry-ldap-auth

RUN sudo -i -u sentry pip install sentry-ldap-auth

