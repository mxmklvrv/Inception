FROM alpine:3.22

RUN apk update && apk add mariadb mariadb-client

COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT [ "/db_setup.sh" ]