#
# All Dockerfile are identical except for the version for the base image and
# the Debian packages
#
FROM postgres:14.2

EXPOSE 5432

# Update apt and current packages
RUN apt-get update && apt-get upgrade

# Install pljava, pgtap, and pgxnclient
RUN apt-get install -y postgresql-14-pljava postgresql-14-pgtap pgxnclient \
            libsaxon-java libsaxonb-java libpostgresql-jdbc-java

# Remove cached files, unnecessary packages, etc.
RUN apt-get autoclean && apt-get autoremove

# Create 'pljava' extension on launch
COPY pljava-vars.sh   /docker-entrypoint-initdb.d/1.pljava-vars.sh
COPY pljava-setup.sql /docker-entrypoint-initdb.d/2.pljava-setup.sql
COPY pljava-saxon.sql /docker-entrypoint-initdb.d/3.pljava-saxon.sql
COPY pljava-test.sql  /docker-entrypoint-initdb.d/4.pljava-test.sql

RUN chmod 0755 /docker-entrypoint-initdb.d/1.pljava-vars.sh
