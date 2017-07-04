FROM postgres:alpine
MAINTAINER Martin Frys <martineez@gmail.com>

ENV POSTGRES_DB pagila
ENV POSTGRES_USER pagila
ENV POSTGRES_PASSWORD pagila

ADD http://pgfoundry.org/frs/download.php/1719/pagila-0.10.1.zip pagila-0.10.1.zip

RUN apk add --no-cache --virtual .build-deps unzip && \
	unzip -j pagila-0.10.1.zip pagila-0.10.1/pagila-insert-data.sql pagila-0.10.1/pagila-schema.sql && \
	sed -i 's/CREATE PROCEDURAL LANGUAGE plpgsql;/CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;/g' /pagila-schema.sql && \
	sed -i 's/OWNER TO postgres;/'"OWNER TO $POSTGRES_USER;"'/g' /pagila-schema.sql && \
	sed -i 's/Owner: postgres/'"Owner: $POSTGRES_USER"'/g' /pagila-schema.sql && \
	sed -i 's/Owner: postgres/'"Owner: $POSTGRES_USER"'/g' /pagila-insert-data.sql && \
	mv /pagila-schema.sql /docker-entrypoint-initdb.d/01-pagila-schema.sql  && \
	mv /pagila-insert-data.sql /docker-entrypoint-initdb.d/02-pagila-insert-data.sql

EXPOSE 5432
CMD ["postgres"]