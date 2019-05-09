# hadolint ignore=DL3007
FROM scandipwa/php:latest
LABEL maintainer="Scandiweb <info@scandiweb.com>"
LABEL authors="Jurijs Jegorovs jurijs+oss@scandiweb.com; Ilja Lapkovskis info@scandiweb.com"

# Set bash by default
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Default configuration, override in deploy/local.env for localsetup
# Do not remove variables, build depends on them,
# just add "" to empty variable, the latest stable version will used instead

# These arguments are defaults, to override them, use .env
# The list of ENVs must be matched to corresponfing ARGs, to persist values in runtime
ARG PROJECT_TAG=local
ARG BASEPATH=/var/www/public
ARG COMPOSER_HOME=/var/lib/composer
ARG COMPOSER_VERSION=latest
ARG COMPOSER_ALLOW_SUPERUSER=1
ARG NODEJS_DIR=/var/lib/node
ARG NODEJS_VERSION=lts
ARG NPM_CONFIG_LOGLEVEL=warn
ARG DOCKER_DEBUG=false
ARG GOSU_GPG_KEY=B42F6819007F00F88E364FD4036A9C25BF357DD4

# Set working directory so any relative configuration or scripts wont fail
WORKDIR $BASEPATH

# Set permissions for non privileged users to use stdout/stderr
RUN chmod augo+rwx /dev/stdout /dev/stderr /proc/self/fd/1 /proc/self/fd/2

ENV TERM=xterm-256color \
    DEBIAN_FRONTEND=noninteractive \
    DOCKER_DEBUG=${DOCKER_DEBUG} \
    CPU_CORES=$(nproc) \
    COMPOSER_ALLOW_SUPERUSER=$(COMPOSER_ALLOW_SUPERUSER) \
    COMPOSER_HOME=/var/lib/composer \
    MAKE_OPTS="-j $CPU_CORES" \
    N_PREFIX=${NODEJS_DIR} \
    PATH=${NODEJS_DIR}/bin:${BASEPATH}/bin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Copy PHP configs
COPY deploy/shared/conf/php/php.ini /usr/local/etc/php/php.ini
COPY deploy/shared/conf/php/docker-php-fpm.conf /usr/local/etc/php-fpm.d/docker.conf

# Copy waiter helper
COPY deploy/wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

# MSMTP config set
RUN { \
        echo 'defaults'; \
        echo 'logfile /proc/self/fd/2'; \
        echo 'timeout 30'; \
        echo 'host maildev'; \
        echo 'tls off'; \
        echo 'tls_certcheck off'; \
        echo 'port 25'; \
        echo 'auth off'; \
        echo 'from no-reply@docker'; \
        echo 'account default'; \
    } | tee /etc/msmtprc
    
# Start script, executed upon container creation from image
COPY deploy/start.sh /start.sh
RUN chmod +x /start.sh

# Clean up APT and temp when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY deploy/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copy project files
COPY src/ $BASEPATH/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

#ENTRYPOINT ["/entrypoint.sh"]
# Spaces in command arguments will result fail to start, put each argument in "" delimited by ,
#CMD ["arg1", "arg2", ""]
CMD ["/start.sh"]

# Print all versions for verification
RUN echo "$(tput setaf 3)php, composer$(tput sgr0)";\
    composer diagnose; printf "\n";\
    echo "$(tput setaf 3)nodejs, npm$(tput sgr0)";\
    npm doctor; printf "\n";