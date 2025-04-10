FROM hub.epicm.org/epicmorg/nextcloud:29

##################################################################
#      thank u, mac users. rolling back normal ZipStreammer
##################################################################
RUN rm -frv /usr/src/nextcloud/lib/private/Streamer.php
ADD Streamer.php /usr/src/nextcloud/lib/private/
RUN chown nobody:nogroup /usr/src/nextcloud/lib/private/Streamer.php
