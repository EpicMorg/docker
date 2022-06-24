# opentracker-docker

Docker image from scratch, customizable, simple and small, for the [opentracker project](https://erdgeist.org/arts/software/opentracker/), a open and free bittorrent tracker.

## How to use this image

This image compile `Opentracker` following [build instructions](https://erdgeist.org/arts/software/opentracker/#build-instructions), but using [GCC](https://gcc.gnu.org/)'s [`-static`](https://gcc.gnu.org/onlinedocs/gcc/Link-Options.html) link option. The `-static` option links a program statically, in other words it does not require a dependency on dynamic libraries at runtime in order to run.

This image is designed to be used in a micro-service environment. There are three versions of the image you can choose from.

The `open` tag contains a Opentracker builded with defaults options and run in [open mode](https://erdgeist.org/arts/software/opentracker/#invocation).

The `blacklist` and `whitelist` tags contains a Opentracker builded with `-DWANT_ACCESSLIST_BLACK` and `-DWANT_ACCESSLIST_WHITE` respectively and run in [closed mode](https://erdgeist.org/arts/software/opentracker/#closed-mode).

## Using in `open` Mode

The image has `/bin/opentracker` binary as [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint) and `-f /etc/opentracker/opentracker.conf` as default [CMD](https://docs.docker.com/engine/reference/builder/#exec-form-entrypoint-example).

So you can run:

```bash
docker run \
  --rm \
  -d \
  --name opentracker \
  -p 6969:6969/udp -p 6969:6969 \
  wiltonsr/opentracker:open
```

Or with `docker-compose.yml` file:

```yml
version: "3"

services:
  tracker:
    image: wiltonsr/opentracker:open
    container_name: opentracker
    restart: always
    ports:
      - 6969:6969/tcp
      - 6969:6969/udp
```

```bash
docker-compose up
```

Now you can access [Opentracker Stats page](https://erdgeist.org/arts/software/opentracker/#statistics) at http://localhost:6969/stats from your host system.

### Debug Mode

All `tags` also contains `/bin/opentracker.debug` binary. So you could run Opentracker in `debug mode` overriding default `ENTRYPOINT`.

```bash
docker run \
  --rm \
  -d \
  --name opentracker \
  -p 6969:6969/udp -p 6969:6969 \
  --entrypoint="/bin/opentracker.debug" \
  wiltonsr/opentracker:open \
  -f /etc/opentracker/opentracker.conf
```

It is also possible to override the default command with:

```bash
docker run \
  --rm \
  --name opentracker \
  -p 6969:6969/udp -p 6969:6969 \
  wiltonsr/opentracker:open \
  -h
```

You will get:

```text
Usage: /bin/opentracker [-i ip] [-p port] [-P port] [-r redirect] [-d dir] [-u user] [-A ip] [-f config] [-s livesyncport]
        -f config include and execute the config file
        -i ip     specify ip to bind to (default: *, you may specify more than one)
        -p port   specify tcp port to bind to (default: 6969, you may specify more than one)
        -P port   specify udp port to bind to (default: 6969, you may specify more than one)
        -r redirecturlspecify url where / should be redirected to (default none)
        -d dir    specify directory to try to chroot to (default: ".")
        -u user   specify user under whose privileges opentracker should run (default: "nobody")
        -A ip     bless an ip address as admin address (e.g. to allow syncs from this address)

Example:   ./opentracker -i 127.0.0.1 -p 6969 -P 6969 -f ./opentracker.conf -i 10.1.1.23 -p 2710 -p 80
```

### Configuration file

All `tags` use default configuration file from [here](https://erdgeist.org/gitweb/opentracker/tree/opentracker.conf.sample).

Some adjusts are made:

- `tracker.user` is setted to `opentracker` [USER](https://docs.docker.com/engine/reference/builder/#user) in all tags.
- `access.whitelist` is setted to `/etc/opentracker/whitelist` in `whitelist` tag.
- `access.blacklist` is setted to `/etc/opentracker/blacklist` in `blacklist` tag.

You could override the default configuration using a [VOLUME](https://docs.docker.com/engine/reference/builder/#volume):

```bash
docker run \
  --rm \
  --name opentracker \
  -v $PWD/local-opentracker.conf:/etc/opentracker/opentracker.conf \
  -p 6969:6969/udp -p 6969:6969 \
  wiltonsr/opentracker:open
```

## Using in `closed` Mode

If you want to control what torrents to track – or not to track. You could use opentracker with one of the accesslist-options `tags`, you can control which torrents are tracked by providing a file that contains a list of human readable `info_hashes`. An example whitelist file would look like

```text
0123456789abcdef0123456789abcdef01234567
890123456789abcdef0123456789abcdef012345
```

### Compilation

Opentracker provides accesslist options, `-DWANT_ACCESSLIST_BLACK` and `-DWANT_ACCESSLIST_WHITE`, but this options are `exclusive`. Trying to compile it with both options will resulte in this error:

```bash
cc -c -o opentracker.o -I../libowfat -Wall -pipe -Wextra  -O3 -DWANT_ACCESSLIST_BLACK -DWANT_ACCESSLIST_WHITE -DWANT_FULLSCRAPE opentracker.c
In file included from opentracker.c:36:
ot_accesslist.h:10:4: error: #error WANT_ACCESSLIST_BLACK and WANT_ACCESSLIST_WHITE are exclusive.
   10 | #  error WANT_ACCESSLIST_BLACK and WANT_ACCESSLIST_WHITE are exclusive.
      |    ^~~~~
make: *** [Makefile:81: opentracker.o] Erro 1
```

Because of that there are two another tags, `blacklist` and `whitelist`, which were compiled with the respective options.

### Whitelist Mode

```bash
docker run \
  --rm \
  --name opentracker \
  -v $PWD/local-whitelist:/etc/opentracker/whitelist \
  -p 6969:6969/udp -p 6969:6969 \
  wiltonsr/opentracker:whitelist
```

### Blacklist Mode

```bash
docker run \
  --rm \
  --name opentracker \
  -v $PWD/local-blacklist:/etc/opentracker/blacklist \
  -p 6969:6969/udp -p 6969:6969 \
  wiltonsr/opentracker:blacklist
```

### Reloading file changes

To make opentracker reload it's `white`/`blacklist` after changes, send a `SIGHUP` unix signal.

```bash
docker kill --signal="SIGHUP" opentracker
```