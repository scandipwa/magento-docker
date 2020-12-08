#!/usr/bin/env bash
set -euo pipefail

mutagen="0"
frontend="0"

start_time="$(date -u +%s.%N)"
### Debug options start
# Uncomment next line for script debug
#set -euxo pipefail

# default value
SCANDIPWA_THEME=${SCANDIPWA_THEME:-"Scandiweb/pwa"}

php-fpm -t
# Do not force container to restart in debug mode
if [ $DOCKER_DEBUG = "true" ]; then
  set +e
fi

### Debug options end

### Custom commands for assets compilation
# Add you custom tasks to execute them before magento static content deploy

################################################################################

# This script prepares docker environment for application

################################################################################

### Default env variables
export COMPOSER_NO_DEV="--no-dev"

### Colors in command output start

function bash_color_library {
  # see if it supports colors...
  ncolors=$(tput colors)
  # shellcheck disable=SC2034
  if test -n "$ncolors" && test $ncolors -ge 8; then

    bold="$(tput bold)"
    underline="$(tput smul)"
    standout="$(tput smso)"
    normal="$(tput sgr0)"
    black="$(tput setaf 0)"
    red="$(tput setaf 1)"
    green="$(tput setaf 2)"
    yellow="$(tput setaf 3)"
    blue="$(tput setaf 4)"
    magenta="$(tput setaf 5)"
    cyan="$(tput setaf 6)"
    white="$(tput setaf 7)"
  fi
}

bash_color_library
bash_colors=$(bash_color_library)
export bash_colors

### Colors in command output end

function pwa_theme_install {
  echo "${blue}${bold}Register PWA theme in Magento${normal}"

  # Theme setup
  magento scandipwa:theme:bootstrap "$SCANDIPWA_THEME" -n || true
  magento setup:upgrade

  if [ $? -eq 0 ]; then
    if [ "$frontend" != "1" ]
    then
      echo "${blue}${bold}Building PWA theme${normal}"
      cd $BASEPATH/app/design/frontend/$SCANDIPWA_THEME
      npm ci
      npm run build
      cd $BASEPATH
    else
      echo "${blue}${bold}Frontend container will build PWA theme${normal}"
    fi
  fi
}

# Empty the redis config caches to avoid errors with module configuration
function magento_flush_config() {
  echo "${blue}${bold}Flushing Magento config cache${normal}"
  /wait-for-it.sh redis:6379 -s -t 5 -- redis-cli -h redis -n 0 flushdb
}

# Apply correct permissions for Magento
function magento_fix_permissions() {
  echo "${blue}${bold}Applying correct permissions to internal folders${normal}"
  chmod -R ugoa+rwX var vendor generated pub/static pub/media app/etc

}

function in_basepath {
  if [ -d $BASEPATH ]; then
    # Change to base directory
    cd $BASEPATH
  else
    echo "${red}${bold}Working directory does not exist or not accessible${normal}"
    exit 1
  fi
}

function composer_install {
  # Check if COMPOSER_AUTH environment variable exists
  if [ -z ${COMPOSER_AUTH+x} ]; then echo "Please set COMPOSER_AUTH environment variable" && exit 1; fi
  # Check environment to install Dev Dependencies on specific ones
  if [ $MAGENTO_MODE = "developer" ]; then
    COMPOSER_NO_DEV=""
  fi

  # Composer install
  echo "${blue}${bold}Installing magento dependencies${normal}"
  composer install $COMPOSER_NO_DEV --ansi --no-interaction --prefer-dist -v
}

function magento_database_config {
  echo "${blue}${bold}Setting magento database credentials${normal}"
  magento setup:config:set \
      --db-host $MYSQL_HOST \
      --db-name $MYSQL_DATABASE \
      --db-user $MYSQL_USER \
      --db-password $MYSQL_PASSWORD \
      --backend-frontname $MAGENTO_ADMINURI \
      -n

  # Redis for persisted query
  echo "${blue}${bold}Setting redis for persisted query(PWA)${normal}"
  bin/magento setup:config:set \
      --pq-host=redis \
      --pq-port=6379 \
      --pq-database=5 \
      --pq-scheme=tcp \
      -n
}

function create_admin_user {
    echo "${blue}${bold}Checking user $MAGENTO_USER ${normal}"
    USER_STATUS=$(magento admin:user:unlock $MAGENTO_USER)
    export USER_STATUS
    if [[ $USER_STATUS =~ "Couldn't find the user account" ]]; then
        magento admin:user:create \
            --admin-firstname $MAGENTO_FIRST_NAME \
            --admin-lastname $MAGENTO_LAST_NAME \
            --admin-email $MAGENTO_EMAIL \
            --admin-user $MAGENTO_USER \
            --admin-password $MAGENTO_PASSWORD

         echo "${blue}${bold}User $MAGENTO_USER created${normal}"
    fi
}


function magento_database_migration {
  # Check if magento already installed or not, ignoring exit statuses of eval, since it's magento subprocess
  set +e
  echo "${blue}${bold}Checking status of the magento database${normal}"
  MAGENTO_STATUS=$(magento setup:db:status)
  export MAGENTO_STATUS
  echo $MAGENTO_STATUS;

  # Set default value
  export ME=0;

  # We cannot rely on Magento Code, as these are update codes, not install codes. Therefore check the output for
  # the specific message!
  if [[ $MAGENTO_STATUS =~ "Magento application is not installed."$ ]]; then
    magento setup:install \
        --admin-firstname $MAGENTO_FIRST_NAME \
        --admin-lastname $MAGENTO_LAST_NAME \
        --admin-email $MAGENTO_EMAIL \
        --admin-user $MAGENTO_USER \
        --admin-password $MAGENTO_PASSWORD \
        --search-engine='elasticsearch7' \
        --elasticsearch-host='elasticsearch' \
        --elasticsearch-port='9200'
  else
    magento setup:db:status
    export ME=$?
    echo "${blue}${bold}DB STATUS: $ME ${normal}"
  fi

  ## Parse exit codes (https://github.com/magento/magento2/blob/2.2-develop/setup/src/Magento/Setup/Console/Command/DbStatusCommand.php)
  # Magento is not installed, then install it
  if [ $ME = 1 ]; then
    echo "${red}${bold}Cannot upgrade: manual action is required! ${normal}"
    # Magento needs upgrade
  elif [ $ME = 2 ]; then
    echo "$yellow$bold Upgrading magento${normal}"
    magento setup:upgrade
    # Check returns All modules updated, move on.
  elif [ $ME = 0 ]; then
    echo "${blue}${bold}No upgrade/install is needed${normal}"
  else
    echo "${red}${bold}Database migration failed: manual action is required!${normal}"
  fi
  if [ $DOCKER_DEBUG != "true" ]; then
    set -e
  fi
}

function magento_redis_config {
  echo "${blue}${bold}Setting redis as config cache${normal}"
  bin/magento setup:config:set \
      --cache-backend=redis \
      --cache-backend-redis-server=redis \
      --cache-backend-redis-db=0 \
      -n

  # Redis for sessions
  echo "${blue}${bold}Setting redis as session storage${normal}"
  bin/magento setup:config:set \
      --session-save=redis \
      --session-save-redis-host=redis \
      --session-save-redis-log-level=3 \
      --session-save-redis-max-concurrency=30 \
      --session-save-redis-db=1 \
      --session-save-redis-disable-locking=1 \
      -n

  # Elasticsearch5 as a search engine
  echo "${blue}${bold}Setting Elasticsearch7 as a search engine${normal}"
  magento config:set catalog/search/engine elasticsearch7

  # elasticsearch container as a host name
  echo "${blue}${bold}Setting elasticsearch as a host name for Elasticsearch5${normal}"
  magento config:set catalog/search/elasticsearch7_server_hostname elasticsearch
  magento cache:enable
}

function magento_varnish_endpoint {
  echo "${blue}${bold}Setting location for Varnish cache flushing${normal}"
  bin/magento setup:config:set --http-cache-hosts=varnish -n
}

function magento_varnish_config {
    echo "${blue}${bold}Setting Varnish config for Magento${normal}"
  magento config:set system/full_page_cache/varnish/access_list "127.0.0.1, app, nginx"
  magento config:set system/full_page_cache/varnish/backend_host nginx
  magento config:set system/full_page_cache/varnish/backend_port 80
  magento config:set system/full_page_cache/caching_application 2
}

function magento_set_mode {
  # Set Magento mode
  if [[ -n ${MAGENTO_MODE+x} ]]; then
    echo "${blue}${bold}Switching magento mode${normal}"
    bin/magento deploy:mode:set $MAGENTO_MODE --skip-compilation
  fi
}

function magento_compile {
  if [[ $MAGENTO_MODE = "production" ]]; then
    echo "${blue}${bold}Generating DI and assets${normal}"
    bin/magento setup:di:compile
    bin/magento setup:static-content:deploy
  fi
}

function magento_set_baseurl {
  if [[ -n ${MAGENTO_BASEURL+x} ]]; then
    echo "${blue}${bold}Setting baseurl to $MAGENTO_BASEURL${normal}"
    magento setup:store-config:set --base-url="$MAGENTO_BASEURL"
  fi
  if [[ -n ${MAGENTO_SECURE_BASEURL+x} ]]; then
    echo "${blue}${bold}Setting secure baseurl to $MAGENTO_SECURE_BASEURL${normal}"
    magento setup:store-config:set --base-url-secure="$MAGENTO_SECURE_BASEURL"
    magento setup:store-config:set --use-rewrites 1
    magento setup:store-config:set --use-secure 0
    magento setup:store-config:set --use-secure-admin 0
  fi
}

function magento_post_deploy {
  echo "${blue}${bold}Flushing caches${normal}"
  magento cache:flush
  echo "${blue}${bold}Disabling maintenance mode${normal}"
  magento maintenance:disable
  magento info:adminuri
}

function exit_catch {
  LAST_EXIT_CODE=$?
  exit ${LAST_EXIT_CODE}
}

function magento_fix_2fa() {
    magento module:disable Magento_TwoFactorAuth
}

function set_theme() {
    # find theme SCANDIPWA_THEME ID
    THEME_ID="$(n98-magerun2 dev:theme:list --format=csv | grep "${SCANDIPWA_THEME}" | cut -d, -f1)"

    if [[ -n ${THEME_ID} ]]; then
        n98-magerun2 config:set design/theme/theme_id "${THEME_ID}"
    fi
}

### Deploy pipe start
helpFunction()
{
   echo ""
   echo "Usage: $0 [-M] [-F]"
   echo -e "\t-F Let frontend container handle theme build"
   echo -e "\t-M Wait for Mutagen to sync files before start"
   exit 1 # Exit script after printing help
}

while getopts "MF" opt
do
   case "$opt" in
      M ) mutagen="1" ;;
      F ) frontend="1" ;;
      ? ) helpFunction ;;
   esac
done

if [ "$mutagen" = "1" ]
then
    echo "${blue}${bold}Waiting for Mutagen to sync initial filese${normal}"
    while ! [ -f ./composer.json -a -f ./composer.lock ]
    do
      sleep 2
    done
fi

# Switch current execution directory to WORKDIR (BASEPATH)
in_basepath
# Installing PHP Composer and packages
composer_install

# Flushing Magento configuration in Redis
magento_flush_config
# Setting magento database credentials
magento_database_config
# Configuring Magento to use Varnish as HTTP cache
magento_varnish_endpoint
# Executing Magento install or migration
magento_database_migration
# Configuring Magento to use Redis for session and config storage
magento_redis_config
# Configure Magento to flush varnish
magento_varnish_config
# Create admin user if not exists
create_admin_user

# Set magento mode
magento_set_mode
# Pwa thme install
pwa_theme_install
# Static content deploy and DI compile, only in production mode
magento_compile

# Set magento baseurl and secure_baseurl
magento_set_baseurl

# Appling correct folder permissions
magento_fix_permissions
# Flushing all caches, removing maintenance mode
magento_post_deploy
# Fixing permissions again due c:f
magento_fix_permissions

# Fixing M2.4 2FA issues
magento_fix_2fa

# Set ScandiPWA as a theme
set_theme

end_time="$(date -u +%s.%N)"

elapsed="$(bc <<<"$end_time-$start_time")"
echo "Deployment executed in $bold$elapsed$normal seconds"

trap exit_catch EXIT
### Deploy pipe end

echo "${blue}${bold}Staring php fpm, ready to rock${normal}"
php-fpm -R
