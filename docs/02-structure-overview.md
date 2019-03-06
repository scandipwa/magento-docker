# Magento 2 Template overview

## Template root
Template root is folder, covered by .git and consists of:
`package(-lock).json` - for documentation development and better offline accessibility
 
`docker-compose.yml` - provides a complete description of infrastructure and internal resource sharing describe. **It should not be changed**

**Please note!** Do not change `docker-compose.yml` until you are not adding/removing or changing a default service 
behavior for ALL environments.

`docker-compose.local.yml` (environment: linux, macos) - full host fs mounting `./src -> /var/www/public`
`docker-compose.remote.yml` - provides file sharing between `app` and `nginx` services for direct assets serving 
 For more details please refer to [06-running-infrastructure](06-running-infrastructure.md)
  
`Dockerfile` - Dockerfile describes build for *App* container. The main container Application is executed with all the necessary tools:
  * PHP: `PHP-FPM` and `PHP-CLI` with `COMPOSER`
  * NodeJS with `NPM` and `N`
  * Ruby with `RBENV` and `GEM`

 
 ### Symlinks (.env and .application)
 All docker-compose files are written to provide possibility to override default values defined in the Dockerfile, so do not change `ARG` or `ENV` values in Dockerfile directly.
 .application and .env files are making Docker template extremely flexible, in terms of versioning and modifications.
  Both files are defined for each environment (*by default: local, dev, staging*) and stored under `deploy/local`, 
  `deploy/development`, `deploy/staging` etc.
 
#### How to use another ENVVAR set:
 1) Remove currently linked files: `rm -f .application .env`
 2) Link proper ENVVAR set: `ln -s deploy/staging/application .application`, `ln -s deploy/staging/env .env`
 
 #### Envvars explained
 `.application` - envvars used by Application (Magento 2) - MySQL connection establishing and Magento 2 automatic 
 install.
  
 `.env` - ENV VARS that specifies configs, port mappings etc. for the services. Partially re-used for Magento 
 configuration. 
 
 All definitions (from both files) are passed as envvars to `app` container by default.
 
 ## /deploy folder
 Deploy folder is holding all configurations there are necessary to build/run the containers:
 * ENVVAR sets (`deployment`, `local`, `staging`. **More can be added easily!**),
 * helper shell scripts: `bootstrap.sh`, `entrypoint.sh`, `wait-for-it.sh`
 * service configs: `shared/conf/nginx`, `shared/conf/php`, `shared/conf/varnish`

## /frontend
Frontend service (container) Dockerfile and `start.sh`.
