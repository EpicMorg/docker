<!-- hub-description: OpenJDK 6-26 (Temurin, Zulu) on Debian trixie with Maven, Gradle and Kotlin -->
# `epicmorg/jdk`

One JDK major version per tag on top of
[`epicmorg/debian:trixie`](https://github.com/EpicMorg/docker/tree/master/linux/ecosystem/base/debian),
with the usual JVM build tools preinstalled. Used as the Java runtime for our
TeamCity agents and Atlassian images.

## What's inside

| Tag | JDK | Build tools |
| --- | --- | ----------- |
| `6` | Azul Zulu `6.22.0.3` (JDK 6u119) | - |
| `7` | Azul Zulu `7.56.0.11` (JDK 7u352) | - |
| `8` | Eclipse Temurin `8u492` | Maven `3.9.16`, Gradle `8.14.5`, Kotlin `2.4.10` |
| `11`, `16` | Eclipse Temurin (`11.0.32`, `16.0.2`) | Maven `3.9.16`, Gradle `8.14.5`, Kotlin `2.4.10` |
| `17` - `26` | Eclipse Temurin (latest GA of each major) | Maven `3.9.16`, Gradle `9.5.1`, Kotlin `2.4.10` |

* JDK in `/usr/local/share/epicmorg/java/<major>`; `JAVA_HOME`, `JDK_HOME` and
  `JRE_HOME` point there, `/usr/jdk` and `/usr/jre` are symlinks to it and
  `${JAVA_HOME}/bin` is on `PATH`.
* Every certificate from `/usr/local/share/ca-certificates` (incl. the EpicMorg CA
  of the base image) is imported into `${JAVA_HOME}/lib/security/cacerts`.
* On `8`+: Maven, Gradle, the Kotlin compiler and Kotlin/Native are unpacked
  under `/usr/local/share/epicmorg/{maven,gradle,kotlin,...}` and their `bin`
  directories are on `PATH`.

## Tags

<!-- readme-sync:tags:begin -->
| Tags | Dockerfile |
| ---- | ---------- |
| `6` | [`jdk6`](jdk6/Dockerfile) |
| `7` | [`jdk7`](jdk7/Dockerfile) |
| `8` | [`jdk8`](jdk8/Dockerfile) |
| `11` | [`jdk11`](jdk11/Dockerfile) |
| `16` | [`jdk16`](jdk16/Dockerfile) |
| `17` | [`jdk17`](jdk17/Dockerfile) |
| `18` | [`jdk18`](jdk18/Dockerfile) |
| `19` | [`jdk19`](jdk19/Dockerfile) |
| `20` | [`jdk20`](jdk20/Dockerfile) |
| `21` | [`jdk21`](jdk21/Dockerfile) |
| `22` | [`jdk22`](jdk22/Dockerfile) |
| `23` | [`jdk23`](jdk23/Dockerfile) |
| `24` | [`jdk24`](jdk24/Dockerfile) |
| `25` | [`jdk25`](jdk25/Dockerfile) |
| `26` | [`jdk26`](jdk26/Dockerfile) |

Every tag is pushed to `docker.io`, `quay.io` and `ghcr.io` (`epicmorg/jdk:<tag>` on each) - same digest everywhere.
<!-- readme-sync:tags:end -->

## Usage

```sh
docker run --rm epicmorg/jdk:21 java -version
```

```dockerfile
FROM epicmorg/jdk:21
COPY target/app.jar /opt/app/app.jar
CMD ["java", "-jar", "/opt/app/app.jar"]
```

Add your own CA: put the `.crt` into `/usr/local/share/ca-certificates/` and
import it the same way the image does:

```dockerfile
COPY my-ca.crt /usr/local/share/ca-certificates/my-ca.crt
RUN update-ca-certificates && \
    keytool -importcert -noprompt -keystore "$JAVA_HOME/lib/security/cacerts" \
      -storepass changeit -alias my-ca -file /usr/local/share/ca-certificates/my-ca.crt
```

## Notes

* `6`, `7`, `16`, `18` - `20`, `22` - `24` are end-of-life upstream; they are kept
  for legacy builds and get no new JDK releases.

## Links

* Source: [EpicMorg/docker](https://github.com/EpicMorg/docker) - issues and PRs welcome
* Tags float and are rebuilt weekly; pin by digest for reproducible builds: [Tags, pinning and updates](https://github.com/EpicMorg/docker#tags-pinning-and-updates)
* [CHANGELOG](https://github.com/EpicMorg/docker/blob/master/CHANGELOG.md) - License: MIT
