FROM php:7.2-fpm-alpine

RUN set -xe \
    && apk add --no-cache \
        nginx \
        supervisor

# Install dependencies
RUN set -xe \
	&& apk add --no-cache --virtual .build-deps \
        g++ \
        gcc \
        make \
	    autoconf \
        libpng-dev \
        libxml2-dev \
        icu-dev \
        freetype-dev \
        libjpeg-turbo-dev \
    && pecl install -o -f redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install soap pdo_mysql intl zip opcache xml \
    && apk del --no-network .build-deps

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

COPY etc /etc/

CMD ["supervisord", "-n", "-j", "/supervisord.pid"]
