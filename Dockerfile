FROM postgres:14.2

EXPOSE 5432

# Update apt and current packages
RUN apt-get update && apt-get upgrade

# Install pljava, pgtap, and pgxnclient
RUN apt-get install -y postgresql-14-pljava postgresql-14-pgtap pgxnclient

# Create 'pljava' extension on launch
COPY pljava-setup.sql /docker-entrypoint-initdb.d/pljava-setup.sql
RUN chmod 0755 /docker-entrypoint-initdb.d/pljava-setup.sql
