FROM alpine:3.14

RUN echo "Update System"

RUN apk update

RUN echo "Installing common dependency"

RUN apk add --no-cache zip \
    supervisor \
    nginx 


RUN apk add --no-cache php8 \
    php8-ctype \
    php8-curl \
    php8-dom \
    php8-fpm  \
    php8-fileinfo \
    php8-gd \
    php8-intl \
    php8-json \
    php8-mbstring \
    php8-mysqli \
    php8-opcache \
    php8-openssl \
    php8-phar \
    php8-pdo_mysql \
    php8-tokenizer \
    php8-session \
    php8-xml \
    php8-xmlwriter \
    php8-xmlreader \
    php8-zlib 

RUN echo "Create Sysmlink PHP"

RUN ln -s /usr/bin/php8 /usr/bin/php

RUN echo "Preparing Workdir"

RUN mkdir -p /var/www/html

WORKDIR /var/www/html


COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./default.conf /etc/nginx/http.d/default.conf
COPY ./command.sh /tmp/command.sh
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

EXPOSE 80
