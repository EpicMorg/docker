FROM docker.io/epicmorg/nextcloud:26

##################################################################
#      thank u, mac users. rolling back normal ZipStreammer
##################################################################
RUN set -eux; \
    f=/usr/src/nextcloud/lib/private/Streamer.php; \
    grep -qE "new ZipStreamer\(\[[\"']zip64[\"'][[:space:]]*=>[[:space:]]*(true|false)\]" "$f"; \
    sed -i -E "s/(new ZipStreamer\(\[[\"']zip64[\"'][[:space:]]*=>[[:space:]]*)false(\])/\1true\2/g" "$f"; \
    grep -nE "new ZipStreamer\(" "$f"; \
    ! grep -qE "zip64[[:space:]]*=>[[:space:]]*false" "$f"
