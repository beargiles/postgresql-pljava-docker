# What is PL/Java?

(work in progress...)

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

## What is pgTAP?

[pgTAP](https://pgtap.org/) provides a [TAP](https://testanything.org/) mechanism for PostgreSQL
unit testing. It allows us to run tests in the database itself. It's useful when writing tests
for stored procedures - and **very** useful when writing tests for java-based user-defined
functions (UDF) and user-defined types (UDT).

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

