![Atlassian Jira Server](https://www.atlassian.com/dam/wac/legacy/jira_logo_landing.png)
  
# Overview
 
This Docker unofficial container makes it easy to get an instance of Jira up and running.
 
## Memory / Heap Size

If you need to override Jira Server's default memory allocation, you can control the minimum heap (Xms) and maximum heap (Xmx) via the below environment variables.

* `JVM_MINIMUM_MEMORY` (default: 1024m)

   The minimum heap size of the JVM

* `JVM_MAXIMUM_MEMORY` (default: 1024m)

   The maximum heap size of the JVM

## Reverse Proxy Settings

If Jira is run behind a reverse proxy server, then you need to specify extra options to make Jira aware of the setup. They can be controlled via the below environment variables.

* `CATALINA_CONNECTOR_PROXYNAME` (default: NONE)

   The reverse proxy's fully qualified hostname.

* `CATALINA_CONNECTOR_PROXYPORT` (default: NONE)

   The reverse proxy's port number via which Jira is accessed.

* `CATALINA_CONNECTOR_SCHEME` (default: http)

   The protocol via which Jira is accessed.

* `CATALINA_CONNECTOR_SECURE` (default: false)

   Set 'true' if CATALINA_CONNECTOR_SCHEME is 'https'.

## JVM configuration

If you need to pass additional JVM arguments to Jira such as specifying a custom trust store, you can add them via the below environment variable

* `JVM_SUPPORT_RECOMMENDED_ARGS`
