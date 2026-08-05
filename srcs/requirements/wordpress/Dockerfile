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

#WP-CLI is running out of PHP memory while extracting WordPress, so increased to 512
RUN sed -i 's/^memory_limit = .*/memory_limit = 512M/' /etc/php84/php.ini

# there is no binary named php in Alpine, creating a symlink
RUN ln -sf /usr/bin/php84 /usr/local/bin/php

COPY tools/wp_setup.sh /wp_setup.sh

#removed the default pool and replace with handmade
RUN rm -f /etc/php84/php-fpm.d/www.conf

COPY conf/wp.conf /etc/php84/php-fpm.d/wp.conf

RUN chmod +x /wp_setup.sh
WORKDIR /var/www/html
EXPOSE 9000

ENTRYPOINT ["/wp_setup.sh"]