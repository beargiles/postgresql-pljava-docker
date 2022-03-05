# What is this docker image?

This docker image extends the official [Postgres docker hub image](https://hub.docker.com/_/postgres)
extended to include the [pljava](https://github.com/tada/pljava/wiki) procedural language. This
extension currently creates a single JVM for each database connection. This is pretty heavy if you
have many short-lived connections but it's a great way to prototype UDF and UDT before committing
to a C implementation for performance.

# How does it work?

The Dockerfile installs the official pl/java package available at the [PostgreSQL apt repo](https://apt.postgresql.org/pub/repos/apt/pool/main/p/postgresql-pljava/). This includes the
'pgxs' application used to load and unload jar files. The Dockerfile also installs [pgTAP](https://pgtap.org/)
(for unit testing) and [pgxnclient](https://pgxn.github.io/pgxnclient/) (PostGreSQL Extension Network)
since anyone writing code in pl/java will definitely want to test it and is likely to be interested in 
additional extensions.

Finally the Dockerfile sets up a simple script that creates the 'java' extension and
grants access to 'java' (but not javau) to PUBLIC.

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
