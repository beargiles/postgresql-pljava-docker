# What are PGXS, PGXN and PL/Java? 

## Introduction

PostgreSQL has rich support for **server** extensions. See
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

This repository provides three new sets of docker images:

- postgres-pgxnclient
- postgres-pljava
- postgres-pljava-dev

### CI/CD (GitHub Actions)

I plan to use GitHub actions to periodically poll the official PostgreSQL images and build new images
as they became available but I've had some problems getting the logic working right. So for now I've
temporarily taken a step back and will only perform a build after pushing an update to this repo.

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

# Extensions available at the official PostgreSQL repository

PostgreSQL maintains an official package repository with the latest releases. For instance for Ubuntu
you should add this to your `/etc/apt/sources.list` file:

```
# keyring: from 'apt.postgresql.org.gpg'
deb [arch=amd64 signed-by=/usr/share/keyrings/papt.postgresql.org.gpg] http://apt.postgresql.org/pub/repos/apt jammy-pgdg main
```

with the specified keyring downloaded and added to your system.

A large number of extensions have already been packaged for your system - you usually do not need
to take any additional steps beyond installing the respective package.

- pg-activity - Realtime PostgreSQL database server monitoring tool
- pg-cloudconfig - Set optimized defaults for PostgreSQL in virtual environments
- pg-cron
- pg-rage-terminator-14 - PostgreSQL background worker that kill random sessions.
- pg-rational
- pg-snakeoil
- pgagent - job scheduling engine for PostgreSQL
- pgaudit
- pgcluu - PostgreSQL performance monitoring and auditing tool
- pgmemcache
- pgsphere
- pgstat - Collects PostgreSQL statistics the same way as a vmstat tool
- pgtop - PostgreSQL performance monitoring tool akin to top
- postgis-java
- postgresql-pgmp - PostgreSQL extension for multiple-precision math
- postgresql-pllua - PostgreSQL extension for LUA
- postgresql-plsh - PostgreSQL extension for shell scripts

The debian packages (bookworm and PostgreSQL repo) are

- postgresql-15-asn1oid - ASN.1 OID data type for PostgreSQL
- postgresql-15-auto-failover - Postgres high availability support
- postgresql-15-bgw-replstatus - report whether PostgreSQL node is master or standby
- postgresql-15-credcheck - PostgreSQL username/password checks
- postgresql-15-cron - Run periodic jobs in PostgreSQL
- postgresql-15-debversion - Debian version number type for PostgreSQL
- postgresql-15-decoderbufs - logical decoder output plugin to deliver data as Protocol Buffers
- postgresql-15-dirtyread - Read dead but unvacuumed tuples from a PostgreSQL relation
- postgresql-15-extra-window-functions - Extra Window Functions for PostgreSQL
- postgresql-15-first-last-agg - PostgreSQL extension providing first and last aggregate functions
- postgresql-15-hll - HyperLogLog extension for PostgreSQL
- postgresql-15-hypopg - PostgreSQL extension adding support for hypothetical indexes.
- postgresql-15-icu-ext - PostgreSQL extension exposing functionality from the ICU library
- postgresql-15-ip4r - IPv4 and IPv6 types for PostgreSQL 15
- postgresql-15-jsquery - PostgreSQL JSON query language with GIN indexing support
- postgresql-15-londiste-sql - SQL infrastructure for Londiste
- postgresql-15-mimeo - specialized, per-table replication between PostgreSQL instances
- postgresql-15-mysql-fdw - Postgres 15 Foreign Data Wrapper for MySQL
- postgresql-15-numeral - numeral datatypes for PostgreSQL
- postgresql-15-ogr-fdw - PostgreSQL foreign data wrapper for OGR
- postgresql-15-omnidb - PostgreSQL PL/pgSQL debugger extension for OmniDB
- postgresql-15-oracle-fdw - PostgreSQL Foreign Data Wrapper for Oracle
- postgresql-15-orafce - Oracle support functions for PostgreSQL 15
- postgresql-15-partman - PostgreSQL Partition Manager
- postgresql-15-periods - PERIODs and SYSTEM VERSIONING for PostgreSQL
- postgresql-15-pgauditlogtofile - PostgreSQL pgAudit Add-On to redirect audit logs
- postgresql-15-pgaudit - PostgreSQL Audit Extension
- postgresql-15-pg-catcheck - Postgres system catalog checker
- postgresql-15-pg-checksums - Activate/deactivate/verify PostgreSQL data checksums
- postgresql-15-pgextwlist - PostgreSQL Extension Whitelisting
- postgresql-15-pg-fact-loader - Build fact tables asynchronously with Postgres
- postgresql-15-pg-failover-slots - High-availability support for PostgreSQL logical replication
- postgresql-15-pgfincore - set of PostgreSQL functions to manage blocks in memory
- postgresql-15-pgl-ddl-deploy - Transparent DDL replication for PostgreSQL
- postgresql-15-pglogical - Logical Replication Extension for PostgreSQL
- postgresql-15-pglogical-ticker - Have time-based replication delay for pglogical
- postgresql-15-pgmemcache - PostgreSQL interface to memcached
- postgresql-15-pgmp - arbitrary precision integers and rationals for PostgreSQL 15
- postgresql-15-pgpcre - Perl Compatible Regular Expressions (PCRE) extension for PostgreSQL
- postgresql-15-pgpool2 - connection pool server and replication proxy for PostgreSQL - modules
- postgresql-15-pgq3 - Generic queue for PostgreSQL
- postgresql-15-pgq-node - Cascaded queueing on top of PgQ
- postgresql-15-pg-qualstats - PostgreSQL extension to gather statistics about predicates.
- postgresql-15-pgrouting - Routing functionality support for PostgreSQL/PostGIS
- postgresql-15-pgrouting-scripts - Routing functionality support for PostgreSQL/PostGIS - SQL scripts
- postgresql-15-pgsphere - Spherical data types for PostgreSQL
- postgresql-15-pg-stat-kcache - PostgreSQL extension to gather per-query kernel statistics.
- postgresql-15-pgtap - Unit testing framework extension for PostgreSQL 15
- postgresql-15-pg-track-settings - PostgreSQL extension tracking of configuration settings
- postgresql-15-pgvector - Open-source vector similarity search for Postgres
- postgresql-15-pg-wait-sampling - Extension providing statistics about PostgreSQL wait events
- postgresql-15-pldebugger - PostgreSQL pl/pgsql Debugger API
- postgresql-15-pljava - Java procedural language for PostgreSQL 15
- postgresql-15-pllua - Lua procedural language for PostgreSQL 15
- postgresql-15-plpgsql-check - plpgsql_check extension for PostgreSQL
- postgresql-15-plprofiler - PostgreSQL PL/pgSQL functions performance profiler
- postgresql-15-plproxy - database partitioning system for PostgreSQL 15
- postgresql-15-plr - Procedural language interface between PostgreSQL and R
- postgresql-15-plsh - PL/sh procedural language for PostgreSQL 15
- postgresql-15-pointcloud - PostgreSQL extension for storing point cloud (LIDAR) data
- postgresql-15-postgis-3 - Geographic objects support for PostgreSQL 15
- postgresql-15-postgis-3-scripts - Geographic objects support for PostgreSQL 15 -- SQL scripts
- postgresql-15-powa - PostgreSQL Workload Analyzer -- PostgreSQL 15 extension
- postgresql-15-prefix - Prefix Range module for PostgreSQL
- postgresql-15-preprepare - pre prepare your PostgreSQL statements server side
- postgresql-15-prioritize - Get and set the nice priorities of PostgreSQL backends
- postgresql-15-q3c - PostgreSQL 15 extension used for indexing the sky
- postgresql-15-rational - Precise fractional arithmetic for PostgreSQL
- postgresql-15-rdkit - Cheminformatics and machine-learning software (PostgreSQL Cartridge)
- postgresql-15-repack - reorganize tables in PostgreSQL databases with minimal locks
- postgresql-15-repmgr - replication manager for PostgreSQL 15
- postgresql-15-rum - PostgreSQL RUM access method
- postgresql-15-semver - Semantic version number type for PostgreSQL
- postgresql-15-set-user - PostgreSQL privilege escalation with enhanced logging and control
- postgresql-15-show-plans - Show query plans of currently running PostgreSQL statements
- postgresql-15-similarity - PostgreSQL similarity functions extension
- postgresql-15-slony1-2 - replication system for PostgreSQL: PostgreSQL 15 server plug-in
- postgresql-15-snakeoil - PostgreSQL anti-virus scanner based on ClamAV
- postgresql-15-squeeze - PostgreSQL extension for automatic bloat cleanup
- postgresql-15-tablelog - log changes on tables and restore tables to point in time
- postgresql-15-tdigest - t-digest algorithm for on-line accumulation of rank-based statistics
- postgresql-15-tds-fdw - PostgreSQL foreign data wrapper for TDS databases
- postgresql-15-toastinfo - Show storage structure of varlena datatypes in PostgreSQL
- postgresql-15-unit - SI Units for PostgreSQL
- postgresql-15-wal2json - PostgreSQL logical decoding JSON output plugin

# Dockerization

The PostgreSQL's official docker images are available at [https://hub.docker.com/_/postgres](https://hub.docker.com/_/postgres).
I highly recommend them, especially if you're using [TestContainers](https://testcontainers.com/) since the
Postgres module knows about this repo. (Warning: the module defaults to a very old version of the database.)

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