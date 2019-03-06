# Requirement overview

The list of requirements that must be fulfilled in order to run Docker-based infrastracture:

### Docker CE or Docker for Mac CE (latest) must be installed. 

`docker -v`

### Docker-compose (latest) 

`docker-compose -v`

### Generated keys for Magento 2 repository
1. Login/register using [Magento2 Marketplace](https://account.magento.com/applications/customer/login/)

2. Go to: My profile

3. Go to: Access keys

4. Create/copy existing key details

Use *public key* for username and *private key* for password fields when setting COMPOSER_AUTH parameters.

### Valid SSL certificate
In order to use all features, especially serviceworker, you must have a valid SSL certificate present on the server, 
if your domain name is different from `localhost`. For more details how to set it up for development environment 
please refer to [Development environment](./E-development-environment.md) section.

### Make sure you can run docker without sudo

Add your user to the `docker` group. For more info see [Manage Docker as a non-root user](https://docs.docker.com/install/linux/linux-postinstall/)
