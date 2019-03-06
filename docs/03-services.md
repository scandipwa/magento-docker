# Building the infrastructure

TODO: UPDATE!

Template is using as much of pre-builts and originally shipped images as possible, however, to maintain environment changes we are building APP service container, that contains application, PHP, composer, nodejs and other tools.

All services are defined within docker-compose.yml and can be enabled or disabled depending or project needs.

## List of available services:
* app - **build is required** - application running and maintaining (php, composer, nodejs, gulp, ruby, python). Latest versions available from: [https://hub.docker.com/scandipwa/scandipwa-base](https://hub.docker.com/scandipwa/scandipwa-base)

* varnish - **scandiweb pre-built version is available** - For version list please refer to: [https://hub.docker.com/scandipwa/varnish](https://hub.docker.com/scandipwa/varnish)
* nginx - **build is not required** - container running nginx, based on official images. For version list and 
details please refer to: 
[https://hub.docker.com/_/nginx/](https://hub.docker.com/_/nginx/)
* mysql - **build is not required** - container is running mysql server and has **mysql-cli client installed inside**
. For version list and details please refer to: [https://hub.docker.com/_/mysql/](https://hub.docker.com/_/mysql/)
* redis - **build is not required** - container is running redis and has **redis-cli client installed inside**. For 
version list and details please refer to: [https://hub.docker.com/_/redis/](https://hub.docker.com/_/redis/)
* maildev - **build is not required** - container is running maildev service inside (replaces mailcatcher with a few 
more great features). WebUI is available on *your_host:1080*. Internaly ssmtp is used to forward e-mails to maildev from php mail() function
* [frontend](./F-Frontend-container.md) - **build is required** - **pluggable** container for clientside app 
development for **develpoment envrionment 
only** 
* [SSL-term](./G-SSL-container.md) - **build is not required** - **pluggable** container, that provides SSL termination
* middleware - **build is required** - container, that provides GraphQL request caching

### Optional (disabled by default)
* elasticsearch - **coming up**
