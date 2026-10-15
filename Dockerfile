FROM php:8.3-apache-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git unzip libicu-dev libzip-dev libpng-dev \
    libjpeg62-turbo-dev libfreetype6-dev libxml2-dev libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j2 mysqli intl zip gd soap exif mbstring opcache \
    && a2enmod rewrite headers remoteip \
    && rm -rf /var/lib/apt/lists/*

ARG MOODLE_VERSION=5018
RUN curl -fSL "https://download.moodle.org/download.php/direct/stable501/moodle-5.1.8.tgz" -o /tmp/moodle.tgz \
    && mkdir -p /var/www/html \
    && tar -xzf /tmp/moodle.tgz -C /tmp \
    && cp -a /tmp/moodle/. /var/www/html/ \
    && rm -rf /tmp/moodle /tmp/moodle.tgz \
    && chown -R www-data:www-data /var/www/html \
    && mkdir -p /var/moodledata \
    && chown -R www-data:www-data /var/moodledata

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
COPY php.ini /usr/local/etc/php/conf.d/99-moodle.ini
COPY entrypoint.sh /usr/local/bin/moodle-entrypoint
RUN chmod +x /usr/local/bin/moodle-entrypoint
ENTRYPOINT ["moodle-entrypoint"]
CMD ["apache2-foreground"]
