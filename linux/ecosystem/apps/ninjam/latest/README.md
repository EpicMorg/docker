# Compose example

```ymlservices:
  ninjam:
    hostname: ninjam
    container_name: ninjam
    image: "epicmorg/ninjam:latest"
    restart: always
    ports:
      - "1234:1234"
      - "1234:1234/udp"
    volumes:
      - /etc/localtime:/etc/localtime
      - /etc/timezone:/etc/timezone
      - logs:/app/log:rw                                    #log file folder
      - archive:/app/archive:rw                             #archive folder
      - /some/place/config.cfg:/app/bin/config.cfg          #binded config.cfg with custom settings
      - /some/place/motd.txt:/app/bin/motd.txt              #binded motd.txt with custom welcome screen
      - /some/place/mylicense.txt:/app/bin/mylicense.txt    #binded license.txt with custom license screen
    environment:
      NINJAM_PORT: 1234
      NINJAM_CONFIG: config.cfg
    tmpfs:
      - /tmp
volumes:
  logs:
    external: true
  archive:
    external: true
```

# ENV Defaults

```bash
ENV NINJAM_CONFIG=config.cfg
ENV NINJAM_PORT=2049
ENV NINJAM_UID=1337
ENV NINJAM_DIR=/app
ENV NINJAM_BIN=${NINJAM_DIR}/bin
ENV NINJAM_ARCHIVE=${NINJAM_DIR}/archive
ENV NINJAM_LOG=${NINJAM_DIR}/log
ENV NINJAM_RUN=${NINJAM_DIR}/run
ENV NINJAM_LOGFILE=${NINJAM_LOG}/ninjamserver.log
ENV NINJAM_PID=${NINJAM_RUN}/ninjamserver.pid
``````

## What is NINJAM?
NINJAM is open source (GPL) software to allow people to make real music together via the Internet. Every participant can hear every other participant. Each user can also tweak their personal mix to his or her liking. NINJAM is cross-platform, with clients available for macOS, Linux, and Windows. REAPER (our digital audio workstation software) also includes NINJAM support (ReaNINJAM plug-in).
NINJAM uses compressed audio which allows it to work with any instrument or combination of instruments. You can sing, play a real piano, play a real saxophone, play a real guitar with whatever effects and guitar amplifier you want, anything. If your computer can record it, then you can jam with it (as opposed to MIDI-only systems that automatically preclude any kind of natural audio collaboration1).

Since the inherent latency of the Internet prevents true realtime synchronization of the jam2, and playing with latency is weird (and often uncomfortable), NINJAM provides a solution by making latency (and the weirdness) much longer.

Latency in NINJAM is measured in measures, and that's what makes it interesting.

The NINJAM client records and streams synchronized intervals of music between participants. Just as the interval finishes recording, it begins playing on everyone else's client. So when you play through an interval, you're playing along with the previous interval of everybody else, and they're playing along with your previous interval. If this sounds pretty bizarre, it sort of is, until you get used to it, then it becomes pretty natural. In many ways, it can be more forgiving than a normal jam, because mistakes propagate differently.

Part tool, part toy, NINJAM is designed with an emphasis on musical experimentation and expression.

## How does NINJAM work?

NINJAM uses OGG Vorbis audio compression to compress audio, then streams it to a NINJAM server, which can then stream it to the other people in your jam. This architecture requires a server with adequate bandwidth, but has no firewall or NAT issues. OGG Vorbis is utilized for its great low bitrate characteristics and performance. Each user receives a copy of other users audio streams, allowing for each user to adjust the mix to their liking, as well as remix later. This uses more bandwidth than having a server encode a single stream, but has numerous benefits (including lower server CPU use and the client having the full multichannel data for later use).
NINJAM can also save all of the original uncompressed source material, for doing full quality remixes after the jam.


(1): While MIDI has many wonderful uses, it also has substantial limitations when working with real instruments.
(2): Limitations of note: sound hardware latency (>5ms), perceptual CODEC latency (>20ms), plus typical and theoretical network latency (>40ms).

## NINJAM Server:
The main requirement for running the server is outbound bandwidth. For example, a 4 person jam needs approximately 768kbps of outbound (and only 240kbps inbound) bandwidth, and a 8 person jam requires approximately 3mbps of outbound (and 600kbps inbound) bandwidth.

## NINJAM server setup guide
To set up a NINJAM server, first find a host that has an abundance of outbound bandwidth. Or if you want to use NINJAM on a LAN with all of the hosts local, that is an option as well. The server can currently run on Windows, OS X, Linux, and FreeBSD. To download the server for your platform, see the download page.
To install the server, extract the archive (or copy the contents of the .dmg if on a mac) to a directory, then edit the example configuration file to suit your needs. Here is a list of the configuration items and what they mean:

Port n - port for server to listen on. The default is 2049.
ServerLicense filename.txt - forces users to view and agree to the license provided to connect. This is useful if you want to run a public server and make people who contribute to a jam license their parts under a Creative Commons or similar license (or whatever license you choose)
MaxUsers n - maximum number of users allowed.
MaxChannels n n - set the maximum channels per user for normal (first parameter) and anonymous (second parameter) users.
SetLog filename - logs to file named "filename". If not specified, logs to standard output.
SessionArchive path interval - if set, archives all recordings to the path provided, and creates a new subdirectory every "interval" minutes. If interval is 0, the interval is 30 seconds.
DefaultTopic topic - default server topic.
DefaultBPM bpm - default server BPM (range 20 to 400)
DefaultBPI bpi - default server BPI (range 2 to 1024)
AnonymousUsers yes|no|multi - allow users to log in anonymously (if no, only users with a valid login/password will be allowed). If multi is specified, then multiple anonymous users from the same IP with the same nickname can log in.
AnonymousUsersCanChat yes|no - allow anonymous users to send chat messages (if no, they can play, but can't contribute to the chat)
AnonymousMaskIP yes|no - if yes, mask the last number in anonymous users' addresses.
AllowHiddenUsers yes|no - if no, users without any channels will appear in the user list. otherwise, they will not.
User username password [permissions] - This adds an authorized user to the user list. If permissions are specified, the default permissions are overridden. Specify * for all access, or include any combination of the following to enable them:

```
C - allow this user to chat with other users
T - allow this user to set the server topic
B - allow this user to adjust BPM / BPI of server
K - allow this user to kick other people
R - allow this user to log in even when server is full
M - allow this user to log in multiple times
```

ACL mask allow|deny|reserve - This adds an entry to the Access Control List (ACL). The configuration file can have any number of these, and the first match is used. mask is in the format of x.x.x.x/y, i.e. 192.168.0.0/16 or 66.88.120.240/28. allow specifies to allow connections, deny specifies to not, and reserve specifies to always allow (even if there are too many users connected).
SetKeepAlive n - sets connection keepalive time to "n" seconds. Recommended value is 3.
SetPID filename - writes process PID to "filename". Only valid on non-Windows systems.


Once you've set the configuration the way you think you will like it, you can run the server:
On OS X/Linux/FreeBSD (OS X will require you to open a terminal and go to the proper directory):
./ninjamsrv configfilename.cfg
On Windows (after opening a command line, and going to the proper directory):
ninjamsrv configfilename.cfg
If you need ot change the configuration once the server is running, you can restart it by hitting R (on Windows), or by using the command "killall -HUP ninjamsrv" (on Linux/FreeBSD/OS X).