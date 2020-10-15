FROM scandipwa/base:magento-2.4.0

LABEL maintainer="Alfreds Genkins alfreds@scandipwa.com"

ENV DEBIAN_FRONTEND=noninteractive

# Install required PHP extensions
RUN pecl install xdebug; \
    docker-php-ext-enable xdebug

EXPOSE 9000
CMD ["php-fpm"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
