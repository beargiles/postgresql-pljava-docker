# What is PL/Java?

[PL/Java](https://github.com/tada/pljava/wiki/) is a PostgreSQL extension that allows us to

- write stored procedures in java
- make custom static methods visible within PostgreSQL

The latter allows us to create user-defined functions (UDF) and user-defined types (UDT).
There is also limited support for foreign data wrappers (FDW).

I wrote a series of articles on how to use PL/Java back in 2011.

- [Introduction to PostgeSQL PL/java, part 1](https://invariantproperties.com/?p=549) (stored procedures)
- [Introduction to PostgeSQL PL/java, part 2: Working with Lists](https://invariantproperties.com/?p=547)
- [Introduction to PostgeSQL PL/java, part 3: Triggers](https://invariantproperties.com/?p=572)
- [Introduction to PostgeSQL PL/java, part 4: User Defined Types](https://invariantproperties.com/?p=590)
- [Introduction to PostgeSQL PL/java, part 5: Operations and Indexes](https://invariantproperties.com/?p=614)

This extension creates a new JVM for each database connection. These docker images are configured
(per [PL/Java VM option recommendations](https://tada.github.io/pljava/install/vmoptions.html)) for
improved performance albeit at the cost of making it impossible to attach to a running instance with
a debugger.

We can get an additional performance boost by pre-compiling the java classes to native libraries
using the Java Ahead-of-Time Compiler (`jaotc`). The PL/Java documentation refers to
[Quicker Clojure startup with AppCDS and AOT](https://web.archive.org/web/20191022103258/http://blog.gilliard.lol/2017/10/04/AppCDS-and-Clojure.html)
for an example of this.


# What is in this docker image?

This docker image extends the official [Postgres docker hub image](https://hub.docker.com/_/postgres)
extended to include the [pljava](https://github.com/tada/pljava/wiki) procedural language. The image
also installs pgTAP and pgxnclient.

## What is pgTAP?

[pgTAP](https://pgtap.org/) provides a [TAP](https://testanything.org/) mechanism for PostgreSQL
unit testing. It allows us to run tests in the database itself. It's useful when writing tests
for stored procedures - and **very** useful when writing tests for java-based user-defined
functions (UDF) and user-defined types (UDT).

## What is PGXN and PGXS?

PGXN is the [**P**ost**g**reSQL E**x**tension **N**etwork](https://wiki.postgresql.org/wiki/PGXN).
It provides a convenient way to find and manage PostgreSQL extensions. It should be checked before
doing substantial work in PL/Java - there's no need to write new code if there's already a decent
extension.

[PGXS](https://wiki.postgresql.org/wiki/Building_and_Installing_PostgreSQL_Extension_Modules) is
used to build and register PGXN projects.

## Are there any other prepackaged extensions?

Yes - check the official [PostgreSQL 'apt' repository](https://wiki.postgresql.org/wiki/Apt).
Some interesting projects are:

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

Debian packages

- postgresql-14-asn1oid - ASN.1 OID data type for PostgreSQL
- postgresql-14-extra-window-functions - Extra Window Functions for PostgreSQL
- postgresql-14-first-last-agg - PostgreSQL extension providing first and last aggregate functions
- postgresql-14-hll - HyperLogLog extension for PostgreSQL
- postgresql-14-hypopg - PostgreSQL extension adding support for hypothetical indexes.
- postgresql-14-icu-ext - PostgreSQL extension exposing functionality from the ICU library
- postgresql-14-omnidb - PostgreSQL PL/pgSQL debugger extension for OmniDB
- postgresql-14-pgpcre - Perl Compatible Regular Expressions (PCRE) extension for PostgreSQL
- postgresql-14-pg-qualstats - PostgreSQL extension to gather statistics about predicates.
- postgresql-14-pg-stat-kcache - PostgreSQL extension to gather per-query kernel statistics.
- postgresql-14-pg-track-settings - PostgreSQL extension tracking of configuration settings
- postgresql-14-plpgsql-check - plpgsql check extension for PostgreSQL
- postgresql-14-pointcloud - PostgreSQL extension for storing point cloud (LIDAR) data
- postgresql-14-powa - PostgreSQL Workload Analyzer -- PostgreSQL 14 extension
- postgresql-14-q3c - PostgreSQL 14 extension used for indexing the sky
- postgresql-14-similarity - PostgreSQL similarity functions extension

# How does it work?

The Dockerfile installs the official pl/java package available at the
[PostgreSQL apt repo](https://apt.postgresql.org/pub/repos/apt/pool/main/p/postgresql-pljava/).
The Dockerfile also installs [pgTAP](https://pgtap.org/) (for unit testing) and
[pgxnclient](https://pgxn.github.io/pgxnclient/) (PostGresql Extension Network) since anyone
writing code in pl/java will definitely want to test it and is likely to be interested in
additional extensions.

Finally the Dockerfile sets up a simple script that creates the 'java' extension and
grants public access to 'java' (but not javau).

# Usage

See the [official PostgreSQL image](https://hub.docker.com/_/postgres) page. This image does nothing
but preinstall pl/java, pgTAP, and pgxnclient.

If you need the minimal viable command use

```
$ docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=password beargiles/pljava
```

# Extensions

A natural extension to this docker image is one that adds a `/docker-entrypoint-initdb.d` script
that defines pl/java-based stored procedures and any UDF/UDT that uses them.

## Custom Java classes

It is possible to add your own java jars to the classpath and make the classes and methods available
to the system. This is particularly useful when you wish to create opaque user-defined functions (UDF)
user-defined types (UDT).

In this case you must add `/usr/share/postgresql/14/pljava/pljava-api-1.6.4.jar` to your claspath
and follow the restrictions listed on the [pl/java wiki](https://github.com/tada/pljava/wiki).
 E.g., only static methods will be visible.

The Dockerfile will then need to be modified to:

* download and build the java code
* add a `/docker-entrypoint-initdb.d` script using 'pgxs' to install the jar(s)

At this point the custom jars will be available for use by any pl/java stored procedure.

# Alternatives

The official list of [prebuilt PL/Java distributions](https://github.com/tada/pljava/wiki/Prebuilt-packages)
includes two additional docker images.

# Source code

The source code is located at [github.com/beargiles/postgresql-pljava-docker](https://github.com/beargiles/postgresql-pljava-docker).

# PL/Java prebuild distribution information:

- {1.6.4,"14.2 (Debian 14.2-1.pgdg110+1)",11.0.14,Linux,amd64}
- {1.6.4,"13.6 (Debian 13.6-1.pgdg110+1)",11.0.14,Linux,amd64}
- {1.6.4,"12.10 (Debian 12.10-1.pgdg110+1)",11.0.14,Linux,amd64}
- {1.5.6,"11.15 (Debian 11.15-1.pgdg90+1)",1.8.0_322,Linux,amd64}
- {1.5.6,"10.20 (Debian 10.20-1.pgdg90+1)",1.8.0_322,Linux,amd64}

