FROM ubuntu:bionic
LABEL maintainer="Ilja Lapkovskis ilja+oss@scandiweb.com"

ARG COMPOSER_HOME=/var/lib/composer
ARG COMPOSER_VERSION=latest
ARG COMPOSER_ALLOW_SUPERUSER=1
ARG NODEJS_DIR=/var/lib/node
ARG NODEJS_VERSION=10.19
ARG GOSU_GPG_KEY=B42F6819007F00F88E364FD4036A9C25BF357DD4

# Set bash by default
SHELL ["/bin/bash", "-c"]

ENV TERM=xterm-256color \
    DEBIAN_FRONTEND=noninteractive \
    DOCKER_DEBUG=${DOCKER_DEBUG} \
    CPU_CORES=$(nproc) \
    COMPOSER_ALLOW_SUPERUSER=$(COMPOSER_ALLOW_SUPERUSER) \
    COMPOSER_HOME=/var/lib/composer \
    MAKE_OPTS="-j $CPU_CORES" \
    N_PREFIX=${NODEJS_DIR} \
    PATH=${NODEJS_DIR}/bin:${BASEPATH}/bin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# persistent / runtime deps
ENV PHPIZE_DEPS \
  autoconf \
  dpkg-dev \
  file \
  g++ \
  gcc \
  libc-dev \
  make \
  pkg-config \
  re2c \
  libcurl4-openssl-dev \
  curl \
  wget \
  openssl \
  bash \
  apt-transport-https \
  git \
  zip \
  unzip \
  autoconf \
  automake \
  nasm \
  pkg-config \
  apt-utils \
  libjpeg-dev \
  libpng-dev \
  libfreetype6-dev \
  zlib1g-dev \
  libicu-dev \
  g++ \
  libmcrypt-dev \
  libxslt1-dev \
  libsodium-dev \
  libargon2-0-dev
  
# Update server packages to latest versions
RUN apt-get -qq update &&\
    apt-get -qq dist-upgrade -y &&\
    apt-get -qq install -y \
    libfreetype6-dev \
    build-essential \
    libicu-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt1-dev \
    redis-tools \
    ca-certificates \
    unzip \
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
    msmtp-mta \
    $PHPIZE_DEPS \
    bison \
    libbison-dev \
    ca-certificates \
    libedit2 \
    libxml2 \
    libcurl4-openssl-dev \
    xz-utils \
    libssl-dev \
    libreadline-dev \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

ENV PHP_INI_DIR /usr/local/etc/php
RUN mkdir -p $PHP_INI_DIR/conf.d

ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data

# Apply stack smash protection to functions using local buffers and alloca()
# Make PHP's main executable position-independent (improves ASLR security mechanism, and has no performance impact on x86_64)
# Enable optimization (-O2)
# Enable linker optimization (this sorts the hash buckets to improve cache locality, and is non-default)
# Adds GNU HASH segments to generated executables (this is used if present, and is much faster than sysv hash; in this configuration, sysv hash is also generated)
# https://github.com/docker-library/php/issues/272
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

ENV GPG_KEYS 1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F

ENV PHP_VERSION 7.2.16
ENV PHP_URL="https://secure.php.net/get/php-7.2.16.tar.xz/from/this/mirror" PHP_ASC_URL="https://secure.php.net/get/php-7.2.16.tar.xz.asc/from/this/mirror"
ENV PHP_SHA256="7d91ed3c1447c6358a3d53f84599ef854aca4c3622de7435e2df115bf196e482" PHP_MD5=""

RUN set -xe; \
  fetchDeps=' \
  '; \
  if ! command -v gpg > /dev/null; then \
    fetchDeps="$fetchDeps \
    dirmngr \
    gnupg \
  "; \
  fi; \
  apt-get update; \
  apt-get dist-upgrade -y; \
  apt-get install -y --no-install-recommends $fetchDeps; \
  rm -rf /var/lib/apt/lists/*; \
  mkdir -p /usr/src; \
  cd /usr/src; \
  wget -O php.tar.xz "$PHP_URL"; \
  if [ -n "$PHP_SHA256" ]; then \
    echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -; \
  fi; \
  if [ -n "$PHP_MD5" ]; then \
    echo "$PHP_MD5 *php.tar.xz" | md5sum -c -; \
  fi; \
  if [ -n "$PHP_ASC_URL" ]; then \
    wget -O php.tar.xz.asc "$PHP_ASC_URL"; \
    export GNUPGHOME="$(mktemp -d)"; \
    for key in $GPG_KEYS; do \
      gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
      gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
      gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
      gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; \
    done; \
    gpg --batch --verify php.tar.xz.asc php.tar.xz; \
    rm -rf "$GNUPGHOME"; \
  fi;

COPY docker-php-source /usr/local/bin/

RUN set -xe \
  && buildDeps=" \
  $PHP_EXTRA_BUILD_DEPS \
  libcurl4-openssl-dev \
  libedit-dev \
  libssl-dev \
  libxml2-dev \
  zlib1g-dev \
  libpng-dev \
  libargon2-0-dev \
  " \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
  \
  && export CFLAGS="$PHP_CFLAGS" \
  CPPFLAGS="$PHP_CPPFLAGS" \
  LDFLAGS="$PHP_LDFLAGS" \
  && chmod +x /usr/local/bin/docker-php-source \
  && docker-php-source extract \
  && cd /usr/src/php \
  && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)" \
# https://bugs.php.net/bug.php?id=74125
  #&& if [ ! -d /usr/include/curl ]; then \
  # ln -sT "/usr/include/$debMultiarch/curl" /usr/local/include/curl; \
  #fi \
  && ./configure \
  --build="$gnuArch" \
  --with-config-file-path="$PHP_INI_DIR" \
  --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
  \
  --disable-cgi \
  \
# --enable-ftp is included here because ftp_ssl_connect() needs ftp to be compiled statically (see https://github.com/docker-library/php/issues/236)
  --enable-ftp \
# --enable-mbstring is included here because otherwise there's no way to get pecl to use it properly (see https://github.com/docker-library/php/issues/195)
  --enable-mbstring \
# --enable-mysqlnd is included here because it's harder to compile after the fact than extensions are (since it's a plugin for several extensions, not an extension in itself)
  --enable-mysqlnd \
# https://wiki.php.net/rfc/argon2_password_hash (7.2+)
  --with-password-argon2 \
  \
  --with-curl \
  --with-libedit \
  --with-openssl \
  --with-zlib \
  --with-sodium \
  \
# bundled pcre does not support JIT on s390x
# https://manpages.debian.org/stretch/libpcre3-dev/pcrejit.3.en.html#AVAILABILITY_OF_JIT_SUPPORT
  $(test "$gnuArch" = 's390x-linux-gnu' && echo '--without-pcre-jit') \
  --with-libdir="lib/$debMultiarch" \
  \
  $PHP_EXTRA_CONFIGURE_ARGS \
  && make -j "$(nproc)" \
  && make install \
  && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
  && make clean \
  && cd / \
  && docker-php-source delete \
  \
# https://github.com/docker-library/php/issues/443
  && pecl update-channels \
  && rm -rf /tmp/pear ~/.pearrc

COPY docker-php-ext-* docker-php-entrypoint /usr/local/bin/

ENTRYPOINT ["docker-php-entrypoint"]

WORKDIR /var/www/html

RUN set -ex \
	&& cd /usr/local/etc \
	&& if [ -d php-fpm.d ]; then \
		# for some reason, upstream's php-fpm.conf.default has "include=NONE/etc/php-fpm.d/*.conf" \
		sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
		cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
	else \
		# PHP 5.x doesn't use "include=" by default, so we'll create our own simple config that mimics PHP 7+ for consistency
		mkdir php-fpm.d; \
		cp php-fpm.conf.default php-fpm.d/www.conf; \
		{ \
			echo '[global]'; \
			echo 'include=etc/php-fpm.d/*.conf'; \
		} | tee php-fpm.conf; \
	fi \
	&& { \
		echo '[global]'; \
		echo 'error_log = /proc/self/fd/2'; \
		echo; \
		echo '[www]'; \
		echo '; if we send this to /proc/self/fd/1, it never appears'; \
		echo 'access.log = /proc/self/fd/2'; \
		echo; \
		echo 'clear_env = no'; \
		echo; \
		echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
		echo 'catch_workers_output = yes'; \
	} | tee php-fpm.d/docker.conf \
	&& { \
		echo '[global]'; \
		echo 'daemonize = no'; \
		echo; \
		echo '[www]'; \
    echo 'pm = dynamic'; \
    echo 'pm.max_children = 25'; \
    echo 'pm.start_servers = 10'; \
    echo 'pm.min_spare_servers = 5'; \
    echo 'pm.max_spare_servers = 10'; \
    echo 'pm.max_requests = 1000'; \
    echo 'pm.process_idle_timeout = 10s'; \
    echo 'listen = [::]:9000'; \
	} | tee php-fpm.d/zz-docker.conf \
  && { \
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

# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/


# Install required PHP extensions
RUN docker-php-ext-install -j$(nproc) \
    gd \
    intl \
    mbstring \
    pdo \
    pdo_mysql \
    phar \
    xsl \
    zip \
    bcmath \
    dom \
    soap

# Install node
RUN set -eux; \
    echo "About to install NodeJS, version: $NODEJS_VERSION"; \
    wget -O - -o /dev/null https://git.io/n-install | N_PREFIX=$NODEJS_DIR bash -s -- -t; \
    wget -O - -o /dev/null https://git.io/n-install | N_PREFIX=$NODEJS_DIR bash -s -- -q $NODEJS_VERSION; \
    npm install npm -g
    
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
          gpg --keyserver keys.gnupg.net --recv-keys "$key" || \
          gpg --keyserver pgp.key-server.io--recv-keys "$key" || \
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

# Install PHP Composer
RUN set -euo pipefail; \
    echo "$(tput setaf 111)Installing php composer$(tput sgr0)"; \
    export EXPECTED_SIGNATURE=$(curl -s -f -L https://composer.github.io/installer.sig); \
    wget -nc -O composer-setup.php https://getcomposer.org/installer; \
    echo "$(tput setaf 111)Checking php composer signature$(tput sgr0)"; \
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
    composer global require hirak/prestissimo;

EXPOSE 9000
CMD ["php-fpm"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
    apt-get purge -y --auto-remove -o \
    APT::AutoRemove::RecommendsImportant=false $fetchDeps
