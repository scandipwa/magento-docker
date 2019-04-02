FROM php:7.2-fpm-stretch
LABEL maintainer="Scandiweb <info@scandiweb.com>"
LABEL authors="Jurijs Jegorovs jurijs+oss@scandiweb.com; Ilja Lapkovskis info@scandiweb.com"

# Set bash by default
SHELL ["/bin/bash", "-c"]

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

# Update server packages to latest versions
RUN apt-get -qq update &&\
    apt-get -qq dist-upgrade -y &&\
    apt-get -qq install -y \
    libfreetype6-dev \
    build-essential \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt1-dev \
    redis-tools \
    ca-certificates \
    unzip \
    nodejs \
    git \
    rsync \
    wget \
    nano \
    vim \
    pv \
    gnupg \
    bc \
    curl \
    msmtp \
    msmtp-mta
    
# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install required PHP extensions

RUN docker-php-ext-install \
  dom \
  gd \
  intl \
  mbstring \
  pdo_mysql \
  xsl \
  zip \
  soap \
  bcmath


ENV TERM=xterm-256color \
    DEBIAN_FRONTEND=noninteractive \
    DOCKER_DEBUG=${DOCKER_DEBUG} \
    CPU_CORES=$(nproc) \
    COMPOSER_ALLOW_SUPERUSER=$(COMPOSER_ALLOW_SUPERUSER) \
    COMPOSER_HOME=/var/lib/composer \
    MAKE_OPTS="-j $CPU_CORES" \
    N_PREFIX=${NODEJS_DIR} \
    PATH=${NODEJS_DIR}/bin:${BASEPATH}/bin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Installing gosu to support Linux machines, used for properly dropping privileges to user
ENV GOSU_VERSION 1.10
RUN set -euo pipefail; \
    \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    \
# verify the signature
  export GNUPGHOME="$(mktemp -d)"; \
  for key in $GOSU_GPG_KEY; do \
          gpg --keyserver keys.gnupg.net --recv-keys "$keys" || \
          gpg --keyserver pgp.key-server.io--recv-keys "$keys" || \
          gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
          gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
          gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
          gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; \
    done; \
  gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
  rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
  \
  chmod +x /usr/local/bin/gosu; \
# verify that the binary works
	gosu nobody true;

# Copy PHP configs
COPY deploy/shared/conf/php/php.ini /usr/local/etc/php/php.ini
COPY deploy/shared/conf/php/docker-php-fpm.conf /usr/local/etc/php-fpm.d/docker.conf

# Copy waiter helper
COPY deploy/wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

# Install PHP Composer
RUN set -euo pipefail; \
    echo "$(tput setaf 4)Installing php composer$(tput sgr0)"; \
    export EXPECTED_SIGNATURE=$(curl -s -f -L https://composer.github.io/installer.sig); \
    wget -nc -O composer-setup.php https://getcomposer.org/installer; \
    echo "$(tput setaf 4)Checking php composer signature$(tput sgr0)"; \
    echo "$EXPECTED_SIGNATURE" composer-setup.php | sha384sum -c - ; \
    \
    if [ -n "$COMPOSER_VERSION" ] && [ "$COMPOSER_VERSION" != "latest" ]; then \
      COMPOSER_VERSION_OVERRIDE="--version=$COMPOSER_VERSION"; \
    else COMPOSER_VERSION_OVERRIDE=""; \
    fi; \
    php composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer $COMPOSER_VERSION_OVERRIDE; \
    rm composer-setup.php; \
    # Ensure cache folder is available \
    echo "The compose home dir is: $COMPOSER_HOME"; \
    # Install prestissimo, multithread install helper \
    composer global require hirak/prestissimo; \
    chmod augo+rwx $COMPOSER_HOME;

# NodeJS install with n manager
# Install node
RUN set -eux; \
    wget -O - -o /dev/null https://git.io/n-install | N_PREFIX=$NODEJS_DIR bash -s -- -t; \
    wget -O - -o /dev/null https://git.io/n-install | N_PREFIX=$NODEJS_DIR bash -s -- -q $NODEJS_VERSION; \
    npm install npm -g

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
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* $BASEPATH/bootstrap.sh

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
    composer diagnose; printf "\n"; \
    #echo "$(tput setaf 118)ruby, bundler$(tput sgr0)";\
    #bundle env; printf "\n"; \
    echo "$(tput setaf 3)nodejs, npm$(tput sgr0)";\
    npm doctor; printf "\n";