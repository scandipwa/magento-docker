# App service running

Application service has a complex logic to automate routine actions, therefore it is utilizing external scripts on startup:
* entrypoin.sh - [ADVANCED] start GOSU and serves for solving internal user inconsistency
* start.sh - is execute on each container startup. 

### Startup logic
TODO: Update this section!

Located under: `/deploy/start.sh`

Script consist of 3 steps:
* prepare - check for $COMPOSER_AUTH and perform composer install depending on $PROJECT_TAG (located under `/
.env`) determines if dev dependencies must be installed. These are installed when set to $PROJECT_TAG="local".

* install - determines the state of database and configs to decide on: *update*, *install* or *do nothing*. There 
might be circumstances, when magento requires manual actions, otherwise container will keep restarting. For 
inconvenience, there is a `$DOCKER_DEBUG` flag (located under `/.env`) that prevent container from restart loop. 
**Normally `$DOCKER_DEBUG` must be set to "false".** 

* finish - sets additional settings, like redis, deploy mode, an more (add when necessary)  and performs a cache flush and maintenance mode disable.
