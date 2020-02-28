![Atlassian Fisheye](https://wac-cdn.atlassian.com/dam/jcr:0785bca2-a166-47ef-aeec-c657e7627af0/Fisheye@2x-blue.png?cdnVersion=363)
![Atlassian Crucible](https://wac-cdn.atlassian.com/dam/jcr:b601a46c-ece6-4cda-94ae-d95b1d94cbfd/Crucible@2x-blue.png?cdnVersion=363)

With FishEye you can search code, visualize and report on activity and find for commits, files, revisions, or teammates across SVN, Git, Mercurial, CVS and Perforce.

Atlassian Crucible takes the pain out of code review. Find bugs and improve code quality through peer code review from JIRA or your workflow.

Learn more about Fisheye: [https://www.atlassian.com/software/fisheye](https://www.atlassian.com/software/fisheye)

Learn more about Crucible: [https://www.atlassian.com/software/crucible](https://www.atlassian.com/software/crucible)

# Overview

This Docker container makes it easy to get an instance of Fisheye/Crucible up and running.

# Quick Start

For the `FISHEYE_INST` directory that is used to store the application data (amongst other things) we recommend mounting a host directory as a [data volume](https://docs.docker.com/engine/tutorials/dockervolumes/#/data-volumes), or via a named volume if using a docker version >= 1.9. 

To get started you can use a data volume, or named volumes. In this example we'll use named volumes.

    $> docker volume create --name fecruVolume
    $> docker run -v fecruVolume:/var/atlassian/application-data/fecru --name="fecru" -d -p 8060:8060 epicmorg/fisheye-crucible


**Success**. Fisheye/Crucible is now available on [http://localhost:8060](http://localhost:8060)*

Please ensure your container has the necessary resources allocated to it. We recommend 1GiB of memory allocated to accommodate the application server. See [Supported Platforms](https://confluence.atlassian.com/fisheye/supported-platforms-298976955.html) for further information.
    

_* Note: If you are using `docker-machine` on Mac OS X, please use `open http://$(docker-machine ip default):8060` instead._

## Memory / Heap Size

If you need to override Fisheye/Crucible's default memory allocation, you can control the minimum heap (Xms) and maximum heap (Xmx) via the below environment variables.

* `JVM_MINIMUM_MEMORY` (default: NONE)

   The minimum heap size of the JVM

* `JVM_MAXIMUM_MEMORY` (default: 1024m)

   The maximum heap size of the JVM


## JVM configuration

If you need to pass additional JVM arguments to Fisheye/Crucible, such as specifying a custom trust store, you can add them via the below environment variable

* `FISHEYE_OPTS`

   Additional JVM arguments for Fisheye/Crucible

* `JVM_SUPPORT_RECOMMENDED_ARGS`

   Additional JVM arguments for Fisheye/Crucible. These are appended to `FISHEYE_OPTS`; this option exists only for consistency with other Atlassian Docker images.


## Other configuration

Additional configuration options are available to Fisheye/Crucible:

* `FISHEYE_ARGS`

   The arguments which will be passed to Fisheye when it is started. You can set this to --debug, for example, or --debug-perf if you always want to have Fisheye debugging put into the Fisheye log files. See also [Command line options](https://confluence.atlassian.com/fisheye/command-line-options-298976950.html)
   
* `FISHEYE_LIBRARY_PATH`

   Used to tell Fisheye where it should look to load any additional native libraries

   
Example:

    $> docker run -e JVM_SUPPORT_RECOMMENDED_ARGS=-Djavax.net.ssl.trustStore=/var/atlassian/application-data/fecru/cacerts -v fecruVolume:/var/atlassian/application-data/fecru --name="fecru" -d -p 8060:8060 epicmorg/fisheye-crucible

# Upgrade

To upgrade to a more recent version of Fisheye/Crucible you can simply stop the `fecru` container and start a new one based on a more recent image:

    $> docker stop fecru
    $> docker rm fecru
    $> docker run ... (See above)

As your data is stored in the data volume directory on the host it will still  be available after the upgrade.

_Note: Please make sure that you **don't** accidentally remove the `fecru` container and its volumes using the `-v` option._

# Backup

For evaluations you can use the built-in database that will store its files in the Fisheye/Crucible home directory. In that case it is sufficient to create a backup archive of the docker volume.

If you're using an external database, you can configure Fisheye/Crucible to make a backup automatically each night. This will back up the current state, including the database to the `fecruVolume` docker volume, which can then be archived. Alternatively you can backup the database separately, and continue to create a backup archive of the docker volume to back up the `FISHEYE_INST` directory.

Read more about data recovery and backups: [https://confluence.atlassian.com/fisheye/backing-up-and-restoring-fisheye-data-298976928.html](https://confluence.atlassian.com/fisheye/backing-up-and-restoring-fisheye-data-298976928.html)

# Versioning

The `latest` tag matches the most recent release of Atlassian Fisheye/Crucible. Thus `epicmorg/fisheye-crucible:latest` will use the newest version of Fisheye/Crucible available.

Alternatively you can use a specific major, major.minor, or major.minor.patch version of Fisheye/Crucible by using a version number tag:

* `epicmorg/fisheye-crucible:4`
* `epicmorg/fisheye-crucible:4.6`
* `epicmorg/fisheye-crucible:4.6.1`

All versions from 4.0+ are available

# Support

This Docker container is unsupported and is intended for illustration purposes only.
