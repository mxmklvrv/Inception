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
    php84-curl \
    php84-xml \
    php84-dom \
    php84-xmlwriter \
    curl \
    mariadb-client

RUN mkdir -p /var/www/html

COPY tools/wp_setup.sh /wp_setup.sh

RUN chmod +x /wp_setup.sh

ENTRYPOINT ["/wp_setup.sh"]