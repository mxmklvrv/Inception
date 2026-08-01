FROM alpine:3.22

RUN apk update && apk add \
    php84 \
    php84-fpm \
    php84-mysqli \
    php84-phar \
    php84-json \
    php84-session \
    php84-iconv \
    php84-mbstring \
    curl \
    mariadb-client

COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/wp_setup.sh"]