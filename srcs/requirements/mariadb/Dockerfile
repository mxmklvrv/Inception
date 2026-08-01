FROM alpine:3.22

RUN apk update && apk add mariadb mariadb-client

COPY tools/db_setup.sh /db_setup.sh

RUN chmod +x /db_setup.sh

ENTRYPOINT [ "/db_setup.sh" ]