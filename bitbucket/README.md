![Atlassian Bitbucket Server](https://www.atlassian.com/dam/wac/legacy/bitbucket_logo_landing.png)

Bitbucket Server is an on-premises source code management solution for Git that's secure, fast, and enterprise grade. Create and manage repositories, set up fine-grained permissions, and collaborate on code - all with the flexibility of your servers.

Learn more about Bitbucket Server: <https://www.atlassian.com/software/bitbucket/server>

# Overview

This Docker container makes it easy to get an instance of Bitbucket up and running.

** We strongly recommend you run this image using a specific version tag instead of latest. This is because the image referenced by the latest tag changes often and we cannot guarantee that it will be backwards compatible. **

# Quick Start

For the `BITBUCKET_HOME` directory that is used to store the repository data
(amongst other things) we recommend mounting a host directory as a [data volume](https://docs.docker.com/engine/tutorials/dockervolumes/#/data-volumes), or via a named volume if using a docker version >= 1.9. 

## For Bitbucket 4.12+

In Bitbucket 4.12 and later versions, volume permission is managed by entry scripts. To get started you can use a data volume, or named volumes. In this example we'll use named volumes.

    $> docker volume create --name bitbucketVolume
    $> docker run -v bitbucketVolume:/var/atlassian/application-data/bitbucket --name="bitbucket" -d -p 7990:7990 -p 7999:7999 atlassian/bitbucket-server

## For other versions

Set permissions for the data directory so that the runuser can write to it:

    $> docker run -u root -v /data/bitbucket:/var/atlassian/application-data/bitbucket atlassian/bitbucket-server chown -R daemon  /var/atlassian/application-data/bitbucket
    
Note that this command can be replaced by named volumes.

Start Atlassian Bitbucket Server:

    $> docker run -v /data/bitbucket:/var/atlassian/application-data/bitbucket --name="bitbucket" -d -p 7990:7990 -p 7999:7999 atlassian/bitbucket-server

**Success**. Bitbucket is now available on [http://localhost:7990](http://localhost:7990)*

Please ensure your container has the necessary resources allocated to it.
We recommend 2GiB of memory allocated to accommodate both the application server
and the git processes.
See [Supported Platforms](https://confluence.atlassian.com/display/BitbucketServer/Supported+platforms) for further information.
    

_* Note: If you are using `docker-machine` on Mac OS X, please use `open http://$(docker-machine ip default):7990` instead._

## Reverse Proxy Settings

If Bitbucket is run behind a reverse proxy server as [described here](https://confluence.atlassian.com/bitbucketserver/proxying-and-securing-bitbucket-server-776640099.html),
then you need to specify extra options to make bitbucket aware of the setup. They can be controlled via the below
environment variables.

### Bitbucket Server 5.0 + 

Due to the migration to Spring Boot in 5.0, there are changes to how you set up Bitbucket to run behind a reverse proxy.

In this example, we'll use an environment file. You can also do this via [specifying each environment variable](https://docs.docker.com/engine/reference/run/#env-environment-variables) via the `-e` argument in `docker run`. 

#### secure-bitbucket.env
```
SERVER_SECURE=true
SERVER_SCHEME=https
SERVER_PROXY_PORT=443
SERVER_PROXY_NAME=<Your url here>
```

Then you run Bitbucket as usual

`docker run -v bitbucketVolume:/var/atlassian/application-data/bitbucket --name="bitbucket" -d -p 7990:7990 -p 7999:7999 --env-file=/path/to/env/file/secure-bitbucket.env atlassian/bitbucket-server:5.0`

### Bitbucket Server < 5.0

To set the reverse proxy arguments, you specify the following as environment variables in the `docker run` command

* `CATALINA_CONNECTOR_PROXYNAME` (default: NONE)

   The reverse proxy's fully qualified hostname.

* `CATALINA_CONNECTOR_PROXYPORT` (default: NONE)

   The reverse proxy's port number via which bitbucket is accessed.

* `CATALINA_CONNECTOR_SCHEME` (default: http)

   The protocol via which bitbucket is accessed.

* `CATALINA_CONNECTOR_SECURE` (default: false)

   Set 'true' if CATALINA\_CONNECTOR\_SCHEME is 'https'.

## JVM Configuration (Bitbucket Server 5.0 + only)

If you need to override Bitbucket Server's default memory configuration or pass additional JVM arguments, use the environment variables below

* `JVM_MINIMUM_MEMORY` (default: 512m)

   The minimum heap size of the JVM

* `JVM_MAXIMUM_MEMORY` (default: 1024m)

   The maximum heap size of the JVM

* `JVM_SUPPORT_RECOMMENDED_ARGS` (default: NONE)

   Additional JVM arguments for Bitbucket Server, such as a custom Java Trust Store

## Application Mode Settings (Bitbucket Server 5.0 + only)

This docker image can be run as a [Smart Mirror](https://confluence.atlassian.com/bitbucketserver/smart-mirroring-776640046.html) or as part of a [Data Center](https://confluence.atlassian.com/enterprise/bitbucket-data-center-668468332.html) cluster. 
You can specify the following properties to start Bitbucket as a mirror or as a Data Center node:

* `ELASTICSEARCH_ENABLED` (default: true)

  Set 'false' to prevent Elasticsearch from starting in the container. This should be used if Elasticsearch is running remotely, e.g. for if Bitbucket is running in a Data Center cluster

* `APPLICATION_MODE` (default: default)

   The mode Bitbucket will run in. This can be set to 'mirror' to start Bitbucket as a Smart Mirror. This will also disable Elasticsearch even if `ELASTICSEARCH_ENABLED` has not been set to 'false'.

* `HAZELCAST_NETWORK_MULTICAST` (default: false)

   Data Center: Set 'true' to enable Bitbucket to find new Data Center cluster members via multicast. `HAZELCAST_NETWORK_TCPIP` should not be specified when using this setting.

* `HAZELCAST_NETWORK_TCPIP` (default: false)

   Data Center: Set 'true' to enable Bitbucket to find new Data Center cluster members via TCPIP. This setting requires `HAZELCAST_NETWORK_TCPIP_MEMBERS` to be specified. `HAZELCAST_NETWORK_MULTICAST` should not be specified when using this setting.

* `HAZELCAST_NETWORK_TCPIP_MEMBERS`

   Data Center: List of members that Hazelcast nodes should connect to when HAZELCAST_NETWORK_TCPIP is 'true'

* `HAZELCAST_GROUP_NAME`

   Data Center: Specifies the cluster group the instance should join.

* `HAZELCAST_GROUP_PASSWORD`

   Data Center: The password required to join the specified cluster group.
   
To run Bitbucket as part of a Data Center cluster, create a Docker network and assign the Bitbucket container a static IP. 

Note: Docker networks may support multicast, however the below example shows configuration using TCPIP.

    $> docker network create --driver bridge --subnet=172.18.0.0/16 myBitbucketNetwork
    $> docker run --network=myBitbucketNetwork --ip=172.18.1.1 -e ELASTICSEARCH_ENABLED=false \
        -e HAZELCAST_NETWORK_TCPIP=true -e HAZELCAST_NETWORK_TCPIP_MEMBERS=172.18.1.1:5701,172.18.1.2:5701,172.18.1.3:5701 \
        -e HAZELCAST_GROUP_NAME=bitbucket -e HAZELCAST_GROUP_PASSWORD=mysecretpassword \
        -v /data/bitbucket-shared:/var/atlassian/application-data/bitbucket/shared --name="bitbucket" -d -p 7990:7990 -p 7999:7999 atlassian/bitbucket-server

## JMX Monitoring (Bitbucket Server 5.0 + only)

Bitbucket Server supports detailed JMX monitoring. To enable and configure JMX, use the environment variables below. For further information on JMX configuration, see [Enabling JMX counters for performance monitoring](https://confluence.atlassian.com/bitbucketserver/enabling-jmx-counters-for-performance-monitoring-776640189.html)

* `JMX_ENABLED` (default: false)

   Enable Bitbucket to publish JMX data

* `JMX_REMOTE_AUTH` (default: NONE)

   Set the authentication to use for remote JMX access. This value is required: anything other than "password" or "ssl" will cause remote JMX access to be disabled

* `JMX_REMOTE_PORT` (default: 3333)

   The port used to negotiate a JMX connection. Note: this port is only used during the initial authorization, after which a different RMI port used for data transfer

* `JMX_REMOTE_RMI_PORT` (default: <random>)

   The port used for all subsequent JMX-RMI data transfer. If desired, the RMI data port can be set to the same value as `JMX_REMOTE_PORT` to allow a single port to be used for both JMX authorization and data transfer

* `RMI_SERVER_HOSTNAME` (default: NONE)

   The hostname or IP address that clients will use to connect to the application for JMX monitoring. This must be resolvable by both clients and from the JVM host machine.

* `JMX_PASSWORD_FILE` (default: NONE)

   The full path to the JMX username/password file used to authenticate remote JMX clients. This is required when `JMX_REMOTE_AUTH` is set to "password"

    $> docker run -e JMX_ENABLED=true -e JMX_REMOTE_AUTH=password -e JMX_REMOTE_RMI_PORT=3333 -e RMI_SERVER_HOSTNAME=bitbucket \
        -e JMX_PASSWORD_FILE=/data/bitbucket:/var/atlassian/application-data/bitbucket/jmx.access \
        -v /data/bitbucket:/var/atlassian/application-data/bitbucket --name="bitbucket" -d -p 7990:7990 -p 7999:7999 -p 3333:3333 atlassian/bitbucket-server

# Upgrade

To upgrade to a more recent version of Bitbucket Server you can simply stop the `bitbucket`
container and start a new one based on a more recent image:

    $> docker stop bitbucket
    $> docker rm bitbucket
    $> docker pull atlassian/bitbucket-server:<desired_version>
    $> docker run ... (See above)

As your data is stored in the data volume directory on the host it will still
be available after the upgrade.

_Note: Please make sure that you **don't** accidentally remove the `bitbucket`
container and its volumes using the `-v` option._

# Backup

For evaluations you can use the built-in database that will store its files in the Bitbucket Server home directory. In that case it is sufficient to create a backup archive of the directory on the host that is used as a volume (`/data/bitbucket` in the example above).

The [Bitbucket Server Backup Client](https://confluence.atlassian.com/display/BitbucketServer/Data+recovery+and+backups) is currently not supported in the Docker setup. You can however use the [Bitbucket Server DIY Backup](https://confluence.atlassian.com/display/BitbucketServer/Using+Bitbucket+Server+DIY+Backup) approach in case you decided to use an external database.

Read more about data recovery and backups: [https://confluence.atlassian.com/display/BitbucketServer/Data+recovery+and+backups](https://confluence.atlassian.com/display/BitbucketServer/Data+recovery+and+backups)

# Versioning

The `latest` tag matches the most recent version of this repository. Thus using `atlassian/bitbucket:latest` or `atlassian/bitbucket` will ensure you are running the most up to date version of this image.

However,  we ** strongly recommend ** that for non-eval workloads you select a specific version in order to prevent breaking changes from impacting your setup.
You can use a specific minor version of Bitbucket Server by using a version number
tag: `atlassian/bitbucket-server:4.14`. This will install the latest `4.14.x` version that
is available.


# Issue tracker

Please raise an [issue](https://bitbucket.org/atlassian/docker-atlassian-bitbucket-server/issues) if you encounter any problems with this Dockerfile.

# Support

For product support, go to [support.atlassian.com](https://support.atlassian.com/)