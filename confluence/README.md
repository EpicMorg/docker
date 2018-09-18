![Atlassian Confluence Server](https://www.atlassian.com/dam/wac/legacy/confluence_logo_landing.png)
 
Confluence Server is where you create, organise and discuss work with your team. Capture the knowledge that's too often lost in email inboxes and shared network drives in Confluence – where it's easy to find, use, and update. Give every team, project, or department its own space to create the things they need, whether it's meeting notes, product requirements, file lists, or project plans, you can get more done in Confluence.
 
Learn more about Confluence Server: <https://www.atlassian.com/software/confluence>

You can find the repository for this Dockerfile at <https://hub.docker.com/r/atlassian/confluence-server>
 
# Overview
 
This Docker container makes it easy to get an instance of Confluence up and running.
 
# Quick Start
 
For the directory in the environmental variable `CONFLUENCE_HOME` that is used to store Confluence data
(amongst other things) we recommend mounting a host directory as a [data volume](https://docs.docker.com/userguide/dockervolumes/#mount-a-host-directory-as-a-data-volume):
 
Start Atlassian Confluence Server:
 
    $> docker run -v /data/your-confluence-home:/var/atlassian/application-data/confluence --name="confluence" -d -p 8090:8090 -p 8091:8091 atlassian/confluence-server
 

**Success**. Confluence is now available on [http://localhost:8090](http://localhost:8090)*
 
Please ensure your container has the necessary resources allocated to it.
We recommend 2GiB of memory allocated to accommodate the application server.
See [Supported Platforms](https://confluence.atlassian.com/display/DOC/Supported+platforms) for further information.
     
 
_* Note: If you are using `docker-machine` on Mac OS X, please use `open http://$(docker-machine ip default):8090` instead._
 
## Memory / Heap Size

If you need to override Confluence Server's default memory allocation, you can control the minimum heap (Xms) and maximum heap (Xmx) via the below environment variables.

* `JVM_MINIMUM_MEMORY` (default: 1024m)

   The minimum heap size of the JVM

* `JVM_MAXIMUM_MEMORY` (default: 1024m)

   The maximum heap size of the JVM

## Reverse Proxy Settings

If Confluence is run behind a reverse proxy server, then you need to specify extra options to make Confluence aware of the setup. They can be controlled via the below environment variables.

* `CATALINA_CONNECTOR_PROXYNAME` (default: NONE)

   The reverse proxy's fully qualified hostname.

* `CATALINA_CONNECTOR_PROXYPORT` (default: NONE)

   The reverse proxy's port number via which Confluence is accessed.

* `CATALINA_CONNECTOR_SCHEME` (default: http)

   The protocol via which Confluence is accessed.

* `CATALINA_CONNECTOR_SECURE` (default: false)

   Set 'true' if CATALINA_CONNECTOR_SCHEME is 'https'.

## JVM configuration

If you need to pass additional JVM arguments to Confluence such as specifying a custom trust store, you can add them via the below environment variable

* `JVM_SUPPORT_RECOMMENDED_ARGS`

   Additional JVM arguments for Confluence
   
Example:

    $> docker run -e JVM_SUPPORT_RECOMMENDED_ARGS=-Djavax.net.ssl.trustStore=/var/atlassian/application-data/confluence/cacerts -v confluenceVolume:/var/atlassian/application-data/confluence --name="confluence" -d -p 8090:8090 -p 8091:8091 atlassian/confluence-server

 
# Upgrade
 
To upgrade to a more recent version of Confluence Server you can simply stop the `Confluence`
container and start a new one based on a more recent image:
 
    $> docker stop confluence
    $> docker rm confluence
    $> docker run ... (see above)
 
As your data is stored in the data volume directory on the host, it will still
be available after the upgrade.
 
_Note: Please make sure that you **don't** accidentally remove the `confluence`
container and its volumes using the `-v` option._
 
# Backup
 
For evaluating Confluence you can use the built-in database that will store its files in the Confluence Server home directory. In that case it is sufficient to create a backup archive of the directory on the host that is used as a volume (`/data/your-confluence-home` in the example above).
 
Confluence's [automatic backup](https://confluence.atlassian.com/display/DOC/Configuring+Backups) is currently supported in the Docker setup. You can also use the [Production Backup Strategy](https://confluence.atlassian.com/display/DOC/Production+Backup+Strategy) approach if you're using an external database.
 
Read more about data recovery and backups: [Site Backup and Restore](https://confluence.atlassian.com/display/DOC/Site+Backup+and+Restore)
 
# Versioning
 
The `latest` tag matches the most recent release of Atlassian Confluence Server.
So `atlassian/confluence-server:latest` will use the newest stable version of Confluence Server available.
 
Alternatively, you can use a specific minor version of Confluence Server by using a version number
tag: `atlassian/confluence-server:5.10`. This will install the latest `5.10.x` version that
is available.

For the latest developer (EAP) release use `atlassian/confluence-server:eap`. This will install our latest milestone (not supported for use in production).  
 
# Known Problems
In Mac OS X with Docker version 1.11.0, when running with docker-machine, there is a bug where the directory specified for `CONFLUENCE_HOME` in a volume mount will not have the correct permission, and thus startup fails with a permission denied error:
     Error writing state to confluence.cfg.xml
com.atlassian.config.ConfigurationException: Couldn't save confluence.cfg.xml to /var/atlassian/confluence-home directory.

See https://github.com/docker/docker/issues/4023 for details.

To work around this issue, use a different host operating system other than Mac OSX until a newer release of Docker fixes this issue.
 
# Support

This Docker image is great for evaluating Confluence. However, it does not use an Oracle JDK due to licensing constraints. Instead, it uses OpenJDK which is not supported for running Confluence in production.

To meet our supported platform requirements, you'll need to build your own image based on [Oracle JDK](https://github.com/oracle/docker-images/tree/master/OracleJDK). See [Update the Confluence Docker image to use Oracle JDK ](https://confluence.atlassian.com/display/CONFKB/Update+the+Confluence+Docker+image+to+use+Oracle+JDK) for more info. 

For product support go to [support.atlassian.com](http://support.atlassian.com).

