# Changelog

##[Unreleased]

##1.3.5
* Change this docs - improve readability and structure for automated parsers

##1.3.4
* Changing maildev port for staging to avoid conflict

* Map 80 port when selenium is used (due to the fact application must be reconfigured)

* Add client_max_body_size to prevent 413 Request Entity Too Large on import file upload

* Fix specific mountpoint for static

##1.3.3
* docker-compose.selenium.yml now binds 80 port to host machine!

##1.3.2
* Correct base url is now set during startup

##1.3.1
* Sample env.php enables cache by default

##1.3.0
* docker-compose.development.yml and docker-compose.staging.yml are now merged into docker-compose.indvp.yml

* Selenium container is now available in default stack (requires additional configuration)

##1.2.4
* GOSU now verifies GPG signatures using multiple keyservers to prevent build from failure because of server
inavailability

* NPM installer now uses direct script - attempt to fix issue when node can not be installed during the build phase

* Multiple tips was added by Raivis Dejus

##1.2.3
* maildev service has been added. WebUI available on port 1080 by default (configurable in .env)

* base url was changed to 127.0.0.1 instead of localhost, due to Magento 2 has issues working on "localhost".

* generate devmail.ini to set sendmail_path to utilize SSMTP binary

* php-fpm -t added before execution, to prevent cases when entire app is propagated but FPM can not start because of 
configuration errors.

* maildev service descriptions added

* separate disabled (optional) services section

##1.2.2
*   Separating `flush redis` and `permission fixes` logic for better reuseability

*   Added varnish configuration during init

*   Adding `use_secure` to magento if MAGENTO_SECURE_BASEURL is set, fixes redirect loops for https

*   Magento install handling is back, decision logic was reworked. Job enabled by default.

*   Dropped support for docker-sync, because this solution in unstable

*   package.lock updated for Docsify

*   On linux hosts you must create empty dirs to support single (unified) docker-compose.local.yml, refer to docs for
 details.

##1.2.1
*   Redis is always flushed before installation start, wait for redis to start
*   Implementing correct logic for magento:install, version 1

##1.2.0
*   Fully reworked by Ilja Lapkovskis

*   Operating system specific configuration is merged into sinlge `docker-compose.local.yml`, update your wrappers or
 aliases
*   Fixes for redis cache flushes, now waits for redis to come up and flushes magento configuration cache via redis-cli

*   For Linux (local) systems `$HOST_UID` and `$HOST_GID` not needed anymore, but use `docker-compose exec -u app 
some_command`, refer to docs for details
*   Disabled `bootstrap prepare` and `bootstrap install` due to issues of handling magento upgrade or install, the 
bootup process greatly speeds up so you will see if something broken right away.

##1.1.2
*   Linux: now bundled with `gosu`, requires $HOST_UID to be set, no $HOST_UID is set, container starts as root

*   Switched `/proc/fd/` mount point usage to `/dev/stderr` and `/dev/stdout` for log redirect, this allowes 
unprivileged user to redirect logs to docker engine

*   Added `DOCKER_DEBUG` flag to avoid automatic container restart on script error, use this flag **only** on local 
development

*   Moved from `php` base image to `m2fullstack` to bunlde all core components with default versions, this will avoid
 constant rebuild of project base components during deployments, currently migrated ruby and python, node still installed during build
 
*   Author list grows, thanks a lot

*   $PATH now properly exported to allow arbitary execution of all components and magento from host, so you can run 
`docker-compose exec app magento c:f` to flush the caches

*   `entrypont.sh` is addded and executed along with any container interaction, for Linux system it drops to 
unprivileged user with same UID as running host user, allowing to work without any permission issues on source code

*   `nginx` mount race conditioning, now nginx devepens on php, not opposite

*   Cleaned and refactor of ENV variables to fix conflicts with host system ENVs

*   Dropped support for `docker-sync` mounts in macos, added more strategies to existing mount points. docker-sync 
shows great performance but it lacks stability with magento, when it breaks, project sources are not synced to the container.

##1.1.1

* _Changelog missing_

##1.0 RC1

*   All services now restart on failure with 5 retries, to avoid drainage of instance resources

*   Container versions moves to .env

*   Container names removed in favor of use `-p` to distinct environments, local not affected by this change

*   OS specific overrides added,

*   Port bindings moved to corresponding env files, to be along with version

*   `docker-sync` implemented with exclusion list, README updated accordingly

*   Rework and cleanup of docker templates

*   Default for `local` setup, separate `php.ini` and `php:7.1-debug` with integrated xdebug

*   Added sample `magento-composer.json`, use to bootstrap fresh project

*   `n` to manage `node.js`, `lts` is used by default

*   `rbenv` to manage `ruby`, version `2.5.1` is installed by default, built with max available cores

*   gem `scss-list` is installed by default

*   all additional tools now live in `/usr/local`

*   more detailed version output of modules

*   Port `9000` now exposed instead of binding to host

*   `COMPOSER_AUTH`, `HOST_UID`, 'HOST_GID'  variables is checked before starting, and during `entrypoint` processing

*   `php-fpm` starts as `root`, avoiding any permission issues inside container

*   Varnish images are prepared and automatically built, versions available: `4.1`,`5.0`, `5.1`, `5.2`, `6.0`. All 
built with geoip2 support. Varnish `5.0` is used by default

*   PHP `7.1` with xdebug, just reference it as `php:7.1-debug`

*   Official ElasticSearch image added, CentOS 7 based

*   Official RabbitMQ added, based on alpine

*   `nvm` is removed, use `n` instead
