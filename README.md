# What are PGXS, PGXN and PL/Java? 

## Introduction

PostgreSQL has rich support for server extensions. See
[Chapter 38: Extending SQL](https://www.postgresql.org/docs/15/extend.html).

These extensions are typically used to support:

- new user-defined functions (UDF) [Chapter 38.3: User-Defined Functions](https://www.postgresql.org/docs/15/xfunc.html)
- new user-defined types (UDT) [Chapter 38.13: User-Defined Types](https://www.postgresql.org/docs/15/xtypes.html)
- new procedural languages [Chapter 58: Writing a Procedural Language Handler](https://www.postgresql.org/docs/15/plhandler.html)
- new foreign data wrappers (FDW) [Chapter 59: Writing a Foreign Data Wrapper](https://www.postgresql.org/docs/15/fdwhandler.html)

but there's really no limit to what can be done, for better or worse.

Two widely used extensions that demonstrate this additional functionality are:

- [PostGIS](https://postgis.net/)
- [PGAudit](https://www.pgaudit.org/)

This repository produces three new sets of docker images:

- [postgres-pgxnclient](https://hub.docker.com/repository/docker/beargiles/postgres-pgxnclient/general)
- [postgres-pljava](https://hub.docker.com/repository/docker/beargiles/postgres-pljava/general)
- [postgres-pljava-dev](https://hub.docker.com/repository/docker/beargiles/postgres-pljava-dev/general)

### CI/CD (GitHub Actions)

GitHub actions are run once a week that check the upstream [PostgreSQL repo](https://hub.docker.com/_/postgres)
then builds and deploys these new docker images as required.

Known limitation: for the pljava-dev image the Dockerfile downloads and rebuilds the Debian
source package. This normally creates a predictable source directory. Unfortunately the
authors of the `postgresql-15-pljava` package have decided to include the version of the
[pljava](https://github.com/tada/pljava) library in the source directory name.

For now I'm using a separate CI/CD pipeline and the hardcoded `1.6.4` version but
the pipeline will break when the source package is updated.

This does not affect the `postgres-pljava` image.

## Managing new extensions

Extensions must be properly packaged before they can be used. See
[Chapter 38.17: Packaging Related Objects into an Extension](https://www.postgresql.org/docs/15/extend-extensions.html).
PostgreSQL recommends the use of [PGXS](https://www.postgresql.org/docs/15/extend-pgxs.html) for this.

[PostgreSQL Extension Network (PGXN)](https://pgxn.org/) is a site that tracks published extensions
that use PGXS. It provides a [pgxn-client](https://github.com/pgxn/pgxnclient) that provides a good
abstraction layer over PGXS - it provides a baseline implementation of the functionality required
by most extensions and reduces the need for individual developers to track all changes to the underlying
PGXS infrastructure.

[PL/Java](https://github.com/tada/pljava/wiki) is just one of the procedural languages listed at PGXN.

Many of the extensions available at PGXN are procedural languages, e.g., PL/Java.

# Dockerization

The official PostgreSQL official docker images are available at [https://hub.docker.com/_/postgres](https://hub.docker.com/_/postgres).
There are two Debian releases (bookworm and bullseye) and one Alpine release. I highly recommend them.

Note: this is especially important if you're using [TestContainers](https://testcontainers.com/)
since the Postgres module knows about this repo. (Warning: the module defaults to a very old version of the database.)
You need to add a bit of code for that module to accept other docker images.

This approach breaks down somewhat if your application needs one or more extensions. You want your CI/CD
pipeline to start with the official PostgreSQL image, install known extensions, and then proceed to the next
steps. The second step might be a challenge, esp. if you aren't aware of the official repository.

This repository contains a multistage Docker build that demonstrates how to do this.

## First image: PGXN-Client

The first docker image, `pgxn-client`, installs the PGXN client. It is used as the basis for other
docker images.

It also installs [pgTAP](https://pgtap.org/). It is a [TAP](https://testanything.org/) implementation
for PostgreSQL server unit testing. These tests are run in the database itself, not a client, so it
is able to provide incredibly useful information when writing tests for PGXS-based functionality.

## Second image: PLJava

The second docker image, `pljava`, installs the PL/Java extension.

It also installs OpenJDK.

**Important notes**
- PL/Java is limited to static methods contained within uploaded jars - it does not allow you to use java as a procedural language.
- (iirc) PL/Java uses a separate JVM for each client connection.

### TestContainers

If you're using TestContainers you'll need to take an additional step or two. My tests use

```java
   PostgreSQLContainer getContainer() {
        DockerImageName imageName = DockerImageName.parse("beargiles/postgres-pljava:15.4").asCompatibleSubstituteFor("postgres");
        PostgreSQLContainer db = new PostgreSQLContainer(ImageName);
        db.withImagePullPolicy((s) -> false);
        return db;
    }
```

You'll definitely need the `asCompatibleSubstituteFor()` command.

You might not need the `withImagePullPolicy()` line - I might only need it since I've been doing local development
of these docker images.

## Third image: PLJava-dev

The final docker image, `pljava-dev`, installs a dev environment capable of rebuilding the
Debian packages. In fact the Dockerfile does that as a smoke test.

You can rebuild the packages yourself with the following steps:

```shell
$ cd /usr/local/src
$ apt-get source postgresql-15-pljava
$ cd postgresql-pljava-1.6.4
$ dpkg-buildpackage --build=binary --no-sign
```

(Magic values correspond to 'latest' release as I write this.)

This will create a number of `.deb` files under `/usr/local/src`.

It should go without saying that you should update the changelog file and version to avoid
any confusion with the official packages.

# Alternatives

The official list of [prebuilt PL/Java distributions](https://github.com/tada/pljava/wiki/Prebuilt-packages)
includes two additional docker images.

# Source code

The source code is located at [github.com/beargiles/postgresql-pljava-docker](https://github.com/beargiles/postgresql-pljava-docker).