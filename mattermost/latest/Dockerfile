FROM mattermost/mattermost-enterprise-edition as bootstrap
RUN cd ./bin && \
    ls -las

FROM python:2.7-buster as edit
COPY edit.py /tmp/edit.py
COPY --from=bootstrap /mattermost/bin/mattermost /tmp/mattermost
RUN cd /tmp && \
    ./edit.py

FROM mattermost/mattermost-enterprise-edition
RUN rm -rfv /mattermost/bin/mattermost
COPY --from=edit /tmp/mattermost /mattermost/bin/
RUN cd ./bin && \
    ls -las
