# What is this docker image?

This docker image extends the official [Postgres docker hub image](https://hub.docker.com/_/postgres)
extended to include the [pljava](https://github.com/tada/pljava/wiki) procedural language. This
extension currently creates a single JVM for each database connection. This is pretty heavy if you
have many short-lived connections but it's a great way to prototype UDF and UDT before committing
to a C implementation for performance.

# How does it work?

The Dockerfile installs the official pl/java package available at the [PostgreSQL apt repo](https://apt.postgresql.org/pub/repos/apt/pool/main/p/postgresql-pljava/). This includes the
'pgxs' application used to load and unload jar files.

The Dockerfile also installs [pgTAP](https://pgtap.org/) (for unit testing) and
[pgxnclient](https://pgxn.github.io/pgxnclient/) (PostGresql Extension Network) since anyone
writing code in pl/java will definitely want to test it and is likely to be interested in 
additional extensions.

Finally the Dockerfile sets up a simple script that creates the 'java' extension and
grants access to 'java' (but not javau) to PUBLIC.

# Example use

Simple example:

```
$ docker run -d --name pljava -p 5432:5432 -e POSTGRES_PASSWORD=password beargiles/pljava
```

# Alternatives

The official list of [prebuilt PL/Java distributions](https://github.com/tada/pljava/wiki/Prebuilt-packages)
includes two additional docker images.

# TO DO

Need to add an initialization script that performs tests to verify the extension was properly installed.
