![logo](https://assets.zabbix.com/img/logo/zabbix_logo_500x131.png)

# What is Zabbix?

Zabbix is an enterprise-class open source distributed monitoring solution.

Zabbix is software that monitors numerous parameters of a network and the health and integrity of servers. Zabbix uses a flexible notification mechanism that allows users to configure e-mail based alerts for virtually any event. This allows a fast reaction to server problems. Zabbix offers excellent reporting and data visualisation features based on the stored data. This makes Zabbix ideal for capacity planning.

For more information and related downloads for Zabbix components, please visit https://hub.docker.com/u/zabbix/ and https://zabbix.com

# What is Zabbix web interface?

Zabbix web interface is a part of Zabbix software. It is used to manage resources under monitoring and view monitoring statistics.

# Zabbix web interface images

These are the only official Zabbix web interface Docker images. They are based on Alpine Linux v3.11, Ubuntu 18.04 (bionic) and CentOS 7 images. The available versions of Zabbix web interface are:

    Zabbix web interface 3.0 (tags: alpine-3.0-latest, ubuntu-3.0-latest, centos-3.0-latest)
    Zabbix web interface 3.0.* (tags: alpine-3.0.*, ubuntu-3.0.*, centos-3.0.*)
    Zabbix web interface 3.2 (tags: alpine-3.2-latest, ubuntu-3.2-latest, centos-3.2.*) (unsupported)
    Zabbix web interface 3.2.* (tags: alpine-3.2.*, ubuntu-3.2.*, centos-3.2.*) (unsupported)
    Zabbix web interface 3.4 (tags: alpine-3.4-latest, ubuntu-3.4-latest, centos-3.4.*) (unsupported)
    Zabbix web interface 3.4.* (tags: alpine-3.4.*, ubuntu-3.4.*, centos-3.4.*) (unsupported)
    Zabbix web interface 4.0 (tags: alpine-4.0-latest, ubuntu-4.0-latest, centos-4.0-latest)
    Zabbix web interface 4.0.* (tags: alpine-4.0.*, ubuntu-4.0.*, centos-4.0.*)
    Zabbix web interface 4.2 (tags: alpine-4.2-latest, ubuntu-4.2-latest, centos-4.2.*) (unsupported)
    Zabbix web interface 4.2.* (tags: alpine-4.2.*, ubuntu-4.2.*, centos-4.2.*) (unsupported)
    Zabbix web interface 4.4 (tags: alpine-4.4-latest, ubuntu-4.4-latest, centos-4.4-latest) (unsupported)
    Zabbix web interface 4.4.* (tags: alpine-4.4.*, ubuntu-4.4.*, centos-4.4.*) (unsupported)
    Zabbix web interface 5.0 (tags: alpine-5.0-latest, ubuntu-5.0-latest, centos-5.0-latest, alpine-latest, ubuntu-latest, centos-latest, latest)
    Zabbix web interface 5.0.* (tags: alpine-5.0.*, ubuntu-5.0.*, centos-5.0.*)
    Zabbix web interface 5.2 (tags: alpine-trunk, ubuntu-trunk, centos-trunk)

Images are updated when new releases are published. The image with ``latest`` tag is based on Alpine Linux.

Zabbix web interface available in three editions:
- Zabbix web-interface based on Apache2 web server with MySQL database support
- Zabbix web-interface based on Apache2 web server with PostgreSQL database support
- Zabbix web-interface based on Nginx web server with MySQL database support
- Zabbix web-interface based on Nginx web server with PostgreSQL database support

The image based on Apache2 web server with MySQL database support.

# How to use this image

## Start `zabbix-web-apache-mysql`

Start a Zabbix web-interface container as follows:

    docker run --name some-zabbix-web-apache-mysql -e DB_SERVER_HOST="some-mysql-server" -e MYSQL_USER="some-user" -e MYSQL_PASSWORD="some-password" -e ZBX_SERVER_HOST="some-zabbix-server" -e PHP_TZ="some-timezone" -d zabbix/zabbix-web-apache-mysql:tag

Where `some-zabbix-web-apache-mysql` is the name you want to assign to your container, `some-mysql-server` is IP or DNS name of MySQL server, `some-user` is user to connect to Zabbix database on MySQL server, `some-password` is the password to connect to MySQL server, `some-zabbix-server` is IP or DNS name of Zabbix server or proxy, `some-timezone` is PHP like timezone name and `tag` is the tag specifying the version you want. See the list above for relevant tags, or look at the [full list of tags](https://hub.docker.com/r/zabbix/zabbix-web-apache-mysql/tags/).

## Linking the container to Zabbix server

    docker run --name some-zabbix-web-apache-mysql --link some-zabbix-server:zabbix-server -e DB_SERVER_HOST="some-mysql-server" -e MYSQL_USER="some-user" -e MYSQL_PASSWORD="some-password" -e ZBX_SERVER_HOST="some-zabbix-server" -e PHP_TZ="some-timezone" -d zabbix/zabbix-web-apache-mysql:tag

## Linking the container to MySQL database

    docker run --name some-zabbix-web-apache-mysql --link some-mysql-server:mysql -e DB_SERVER_HOST="some-mysql-server" -e MYSQL_USER="some-user" -e MYSQL_PASSWORD="some-password" -e ZBX_SERVER_HOST="some-zabbix-server" -e PHP_TZ="some-timezone" -d zabbix/zabbix-web-apache-mysql:tag

## Container shell access and viewing Zabbix web interface logs

The `docker exec` command allows you to run commands inside a Docker container. The following command line will give you a bash shell inside your `zabbix-web-apache-mysql` container:

```console
$ docker exec -ti some-zabbix-web-apache-mysql /bin/bash
```

The Zabbix web interface log is available through Docker's container log:

```console
$ docker logs  some-zabbix-web-apache-mysql
```

## Environment Variables

When you start the `zabbix-web-apache-mysql` image, you can adjust the configuration of the Zabbix web interface by passing one or more environment variables on the `docker run` command line.

### `ZBX_SERVER_HOST`

This variable is IP or DNS name of Zabbix server. By default, value is `zabbix-server`.

### `ZBX_SERVER_PORT`

This variable is port Zabbix server listening on. By default, value is `10051`.

### `DB_SERVER_HOST`

This variable is IP or DNS name of MySQL server. By default, value is 'mysql-server'

### `DB_SERVER_PORT`

This variable is port of MySQL server. By default, value is '3306'.

### `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_USER_FILE`, `MYSQL_PASSWORD_FILE`

These variables are used by Zabbix web-interface to connect to Zabbix database. With the `_FILE` variables you can instead provide the path to a file which contains the user / the password instead. Without Docker Swarm or Kubernetes you also have to map the files. Those are exclusive so you can just provide one type - either `MYSQL_USER` or `MYSQL_USER_FILE`!

```console
docker run --name some-zabbix-web-apache-mysql -e DB_SERVER_HOST="some-mysql-server" -v ./.MYSQL_USER:/run/secrets/MYSQL_USER -e MYSQL_USER_FILE=/run/secrets/MYSQL_USER -v ./.MYSQL_PASSWORD:/run/secrets/MYSQL_PASSWORD -e MYSQL_PASSWORD_FILE=/var/run/secrets/MYSQL_PASSWORD -e PHP_TZ="some-timezone" -d zabbix/zabbix-web-apache-mysql:tag
```

With Docker Swarm or Kubernetes this works with secrets. That way it is replicated in your cluster!

```console
printf "zabbix" | docker secret create MYSQL_USER -
printf "zabbix" | docker secret create MYSQL_PASSWORD -
docker run --name some-zabbix-web-apache-mysql -e DB_SERVER_HOST="some-mysql-server" -e MYSQL_USER_FILE=/run/secrets/MYSQL_USER -e MYSQL_PASSWORD_FILE=/run/secrets/MYSQL_PASSWORD -e ZBX_SERVER_HOST="some-zabbix-server" -e PHP_TZ="some-timezone" -d zabbix/zabbix-web-apache-mysql:tag
```

This method is also applicable for `MYSQL_ROOT_PASSWORD` with `MYSQL_ROOT_PASSWORD_FILE`.

By default, values for `MYSQL_USER` and `MYSQL_PASSWORD` are `zabbix`, `zabbix`.

### `MYSQL_DATABASE`

The variable is Zabbix database name. By default, value is `zabbix`.

### `ZBX_HISTORYSTORAGEURL`

History storage HTTP[S] URL. This parameter is used for Elasticsearch setup. Available since 3.4.5.

### `ZBX_HISTORYSTORAGETYPES`

Array of value types to be sent to the history storage. An example: ['uint', 'dbl']. This parameter is used for Elasticsearch setup. Available since 3.4.5.

### `PHP_TZ`

The variable is timezone in PHP format. Full list of supported timezones are available on [`php.net`](http://php.net/manual/en/timezones.php). By default, value is 'Europe/Riga'.

### `ZBX_SERVER_NAME`

The variable is visible Zabbix installation name in right top corner of the web interface.

### `DB_DOUBLE_IEEE754`

Use IEEE754 compatible value range for 64-bit Numeric (float) history values. Available since 5.0.0. Enabled by default.

### `ENABLE_WEB_ACCESS_LOG`

The variable sets the Access Log directive for Web-server. By default, value corresponds to standard output.

### `ZBX_MAXEXECUTIONTIME`

The varable is PHP ``max_execution_time`` option. By default, value is `300`.

### `ZBX_MEMORYLIMIT`

The varable is PHP ``memory_limit`` option. By default, value is `128M`.

### `ZBX_POSTMAXSIZE`

The varable is PHP ``post_max_size`` option. By default, value is `16M`.

### `ZBX_UPLOADMAXFILESIZE`

The varable is PHP ``upload_max_filesize`` option. By default, value is `2M`.

### `ZBX_MAXINPUTTIME`

The varable is PHP ``max_input_time`` option. By default, value is `300`.

### `ZBX_SESSION_NAME`

The variable is Zabbix frontend [definition](https://www.zabbix.com/documentation/4.2/manual/web_interface/definitions). String used as the name of the Zabbix frontend session cookie. By default, value is `zbx_sessionid`.

### `ZBX_DB_ENCRYPTION`

The variable allows to activate encryption for connections to Zabbix database. Even if no other environment variables are specified, connections will be TLS-encrypted if `ZBX_DB_ENCRYPTION=true` specified. Available since 5.0.0. Disabled by default.

### `ZBX_DB_KEY_FILE`

The variable allows to specify the full path to a valid TLS key file. Available since 5.0.0.

### `ZBX_DB_CERT_FILE`

The variable allows to specify the full path to a valid TLS certificate file. Available since 5.0.0.

### `ZBX_DB_CA_FILE`

The variable allows to specify the full path to a valid TLS certificate authority file. Available since 5.0.0.

### `ZBX_DB_VERIFY_HOST`

The variable allows to activate host verification. Available since 5.0.0.

### `ZBX_DB_CIPHER_LIST`

The variable allows to specify a custom list of valid ciphers. The format of the cipher list must conform to the OpenSSL standard. Available since 5.0.0.

## Allowed volumes for the Zabbix web interface container

### ``/etc/ssl/apache2``

The volume allows to enable HTTPS for the Zabbix web interface. The volume must contains two files ``ssl.crt`` and ``ssl.key`` prepared for Apache2 SSL connections.

Please follow official Apache2 [documentation](https://httpd.apache.org/docs/2.4/ssl/ssl_howto.html) to get more details about how to create certificate files.

# The image variants

The `zabbix-web-apache-mysql` images come in many flavors, each designed for a specific use case.

## `zabbix-web-apache-mysql:ubuntu-<version>`

This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of.

## `zabbix-web-apache-mysql:alpine-<version>`

This image is based on the popular [Alpine Linux project](http://alpinelinux.org), available in [the `alpine` official image](https://hub.docker.com/_/alpine). Alpine Linux is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

This variant is highly recommended when final image size being as small as possible is desired. The main caveat to note is that it does use [musl libc](http://www.musl-libc.org) instead of [glibc and friends](http://www.etalabs.net/compare_libcs.html), so certain software might run into issues depending on the depth of their libc requirements. However, most software doesn't have an issue with this, so this variant is usually a very safe choice. See [this Hacker News comment thread](https://news.ycombinator.com/item?id=10782897) for more discussion of the issues that might arise and some pro/con comparisons of using Alpine-based images.

To minimize image size, it's uncommon for additional related tools (such as `git` or `bash`) to be included in Alpine-based images. Using this image as a base, add the things you need in your own Dockerfile (see the [`alpine` image description](https://hub.docker.com/_/alpine/) for examples of how to install packages if you are unfamiliar).

# Supported Docker versions

This image is officially supported on Docker version 1.12.0.

Support for older versions (down to 1.6) is provided on a best-effort basis.

Please see [the Docker installation documentation](https://docs.docker.com/installation/) for details on how to upgrade your Docker daemon.

# User Feedback

## Documentation

Documentation for this image is stored in the [`web-apache-mysql/` directory](https://github.com/zabbix/zabbix-docker/tree/3.0/web-apache-mysql) of the [`zabbix/zabbix-docker` GitHub repo](https://github.com/zabbix/zabbix-docker/). Be sure to familiarize yourself with the [repository's `README.md` file](https://github.com/zabbix/zabbix-docker/blob/master/README.md) before attempting a pull request.

## Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/zabbix/zabbix-docker/issues).

### Known issues

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/zabbix/zabbix-docker/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.
