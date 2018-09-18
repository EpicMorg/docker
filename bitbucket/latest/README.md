![Atlassian Bitbucket Server](https://www.atlassian.com/dam/wac/legacy/bitbucket_logo_landing.png)
 
# Overview

This Docker unofficial container makes it easy to get an instance of Bitbucket up and running.
 
## Reverse Proxy Settings

If Bitbucket is run behind a reverse proxy server as [described here](https://confluence.atlassian.com/bitbucketserver/proxying-and-securing-bitbucket-server-776640099.html),
then you need to specify extra options to make bitbucket aware of the setup. They can be controlled via the below
environment variables.
 
#### Bitbucket Server >= 5.0 secure-bitbucket.env
```
SERVER_SECURE=true
SERVER_SCHEME=https
SERVER_PROXY_PORT=443
SERVER_PROXY_NAME=<Your url here>
```
 
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
 