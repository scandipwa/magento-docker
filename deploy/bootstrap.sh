#!/usr/bin/env bash
set -euo pipefail

# Uncomment next line for script debug
#set -euxo pipefail

################################################################################

# This script builds docker environment for application

# PREREQUISITES

# Set environment variable on machine where build will be executed, do not commit them in source code
#
# Magento auth:
# export COMPOSER_AUTH='{"http-basic":{"repo.magento.com": {"username": "REPLACE_THIS", "password": "REPLACE_THIS"}}}'
#

# CONFIGURATION

# All configuration is set in deploy/<env>/env and application files, use appropriate one to change the settings
# DO NOT COMMIT ANY SENSITIVE INFORMATION THERE, like passwords, tokens.
#
# If variables not set, bootstrap will default to latest stable version, configuration.
# Use ENV variables for overriding
# For sensitive information use Vault

################################################################################

# Get and set some info before start
CPU_CORES=$(nproc)
export CPU_CORES
MAKE_OPTS="-j $CPU_CORES"
export MAKE_OPTS
export TERM=xterm-256color

echo "bash /etc/profile" > /etc/rc.local
echo "exit 0" >> /etc/rc.local
### Composer install with signature check

# Set permissions for non privileged users to use stdout/stderr
chmod augo+rwx /dev/stdout /dev/stderr /proc/self/fd/1 /proc/self/fd/2

function phpcomposer {
  # Check for argument, if none provided, return usage
  if [ $# -eq 0 ]
  then
    echo "Usage:"
    echo "composer install - installs composer"
    echo "composer version - prints version if composer is present"
  fi

  if [ $1 = "install" ]; then
    echo "$(tput setaf 111)Installing php composer$(tput sgr0)"
    EXPECTED_SIGNATURE=$(curl -s -f -L https://composer.github.io/installer.sig)
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

    if [ $EXPECTED_SIGNATURE != $ACTUAL_SIGNATURE ]; then
      echo 'ERROR: Invalid installer signature' 2>&1
      rm composer-setup.php
      exit 1
    fi

    if [ -n "$COMPOSER_VERSION" ] || [ "$COMPOSER_VERSION" != "latest" ]; then
      COMPOSER_VERSION_OVERRIDE="--version=$COMPOSER_VERSION"
    fi
    php composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer #$COMPOSER_VERSION_OVERRIDE
    rm composer-setup.php
    # Ensure cache folder is available
    echo "The compose home dir is: $COMPOSER_HOME"
    mkdir -p $COMPOSER_HOME/cache
    chmod -R 777 $COMPOSER_HOME
  fi
  # Print installed version
  if [ $1 = "version" ]; then
    if [ -n "$(command -v composer)" ]; then
      composer --ansi --version --no-interaction
    else
      echo "php composer is not installed, check build" 2>&1
      exit 1
    fi
  fi
}

### n with NodeJS

function nodejs () {
  # Check for argument, if none provided, return usage
  if [ -z "$1" ]; then
    echo "Usage:"
    echo "nodejs install - installs n with nodejs"
    echo "nodejs version - prints version if nodejs is present"
  fi
  # When "install" passed, install the nvm with node js
  if [ $1 = "install" ]; then
    echo "$(tput setaf 111)Installing node.js$(tput sgr0)"
    # Install n to manage node js versions
    echo "The n home dir is: $NODEJS_DIR"
    # Test for nodejs prerequisites
    curl -L https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | N_PREFIX=$NODEJS_DIR bash -s -- -t
    # Install nodejs
    curl -L https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | N_PREFIX=$NODEJS_DIR bash -s -- -q $NODEJS_VERSION
    # Expose varibles to env
    export N_PREFIX="$NODEJS_DIR"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

    #n $NODEJS_VERSION
    # Update npm
    #curl -0 -L https://npmjs.com/install.sh | sh
    # Install gulp globally with CLI
    npm install --global gulp-cli gulp
    chmod -R 777 $NODEJS_DIR

    ln -snf $(which node) /usr/local/bin/node
    ln -snf $(which npm) /usr/local/bin/npm
    ln -snf $(which n) /usr/local/bin/n

  fi
  if [ $1 = "version" ]; then
    if [ -n "$(command -v node)" ]; then
      echo "$(tput setaf 2)nodejs summary :$(tput sgr0)"
      echo "version $(tput setaf 3)`node -v`$(tput sgr0)"
      echo "path $(tput setaf 3)`which node`$(tput sgr0)"
      echo "npm version $(tput setaf 3)`npm -v`$(tput sgr0)"
      echo "npm path $(tput setaf 3)`which npm`$(tput sgr0)"
      echo "n version $(tput setaf 3)`n --version`$(tput sgr0)"
      echo "n path $(tput setaf 3)`which n`$(tput sgr0)"
    else
      echo "nodejs is not installed, check build" 2>&1
      exit 1
    fi
  fi
}

function ruby {
  if [ -z "$1" ]; then
    echo "Usage:"
    echo "ruby install - installs rbenv with ruby"
    echo "ruby version - prints version if ruby is present"
  fi
  if [ $1 = "install" ]; then
    echo "$(tput setaf 111)Installing rbenv and ruby$(tput sgr0)"
    # Install rbenv
    #echo "git clone git://github.com/sstephenson/rbenv.git $RBENV_ROOT"
    #git clone git://github.com/sstephenson/rbenv.git $RBENV_ROOT

    # Add ruby build plugin to rbenv
    #mkdir -p "$(rbenv root)"/plugins
    #git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

    # Install ruby
    rbenv install -s $RBENV_VERSION
    rbenv global $RBENV_VERSION

    rbenv rehash
    # Production install gems skipping ri and rdoc
    echo "gem: --no-ri --no-rdoc" >> /root/.gemrc

    # Install global gems
    gem install bundler --force
    gem install scss_lint

    chmod -R 777 "$(rbenv root)"
  fi
  if [ $1 = "version" ]; then
    if [ -n "$(command -v ruby)" ]; then
      echo "$(tput setaf 2)ruby summary :$(tput sgr0)"
      echo "version $(tput setaf 3)`ruby -v`$(tput sgr0)"
      echo "path $(tput setaf 3)`which ruby`$(tput sgr0)"
      echo "rubygems version $(tput setaf 3)`gem -v`$(tput sgr0)"
      echo "rubygems path $(tput setaf 3)`which gem`$(tput sgr0)"
      echo "rbenv version $(tput setaf 3)`rbenv --version`$(tput sgr0)"
      echo "rbenv path $(tput setaf 3)`which rbenv`$(tput sgr0)"
    else
      echo "ruby is not installed, check build" 2>&1
      exit 1
    fi
  fi
}

### Main execution pipe

# Toolchain installation
echo "$(tput setaf 111)--- Installing application runtime---$(tput sgr0)"
phpcomposer install
nodejs install
ruby install

# Toolchain binary and version checks
echo "$(tput setaf 111)---Checking versions---$(tput sgr0)"
phpcomposer version
nodejs version
ruby version

echo "$(tput setaf 111)Default env is $(tput sgr0) $(echo $PATH)"
