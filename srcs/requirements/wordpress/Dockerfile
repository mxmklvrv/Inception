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


# there is no binary named php in Alpine, creating a symlink
RUN ln -s /usr/bin/php84 /usr/bin/php

COPY tools/wp_setup.sh /wp_setup.sh
COPY conf/wp.cnf /etc/php84/php-fpm.d/wp.cnf

RUN chmod +x /wp_setup.sh
WORKDIR /var/www/html
EXPOSE 9000

ENTRYPOINT ["/wp_setup.sh"]