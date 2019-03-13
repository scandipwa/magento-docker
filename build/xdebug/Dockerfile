FROM scandipwa/base
LABEL authors="Jurijs Jegorovs jurijs+oss@scandiweb.com"
LABEL maintainer="Jurijs Jegorovs jurijs+oss@scandiweb.com"
ENV DEBIAN_FRONTEND=noninteractive

# Install required PHP extensions
RUN pecl install xdebug; \
    docker-php-ext-enable xdebug
    
# Copy xdebug config
COPY xdebug-config.ini /usr/local/etc/php/conf.d/xdebug-config.ini

EXPOSE 9000
CMD ["php-fpm"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
