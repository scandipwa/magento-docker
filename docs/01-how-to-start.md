# How to start

## Prerequisites

For more details on each please see [A-requirements.md](A-requirements.md).

### Docker and Docker-compose

Docker and docker-compose must be installed (latest)

### Composer Authentification  

`COMPOSER_AUTH` must be set in order to fetch sources from Magento 2 repository.
You may use your own credentials, or project specific (**important working on Commerce (Enterprise) version** ).

`export COMPOSER_AUTH='{"http-basic":{"repo.magento.com": {"username": "", "password": ""}}}'`

You can obtain credentials using [Magento2 Marketplace](https://account.magento.com/applications/customer/login/)

**It is important to execute `export` in the same terminal window you will run `docker-compose up`**
or add it to the .bashrc or corresponding file and reload the terminal window or run `source ~/.bashrc`, depending on your shell and configuration. 

### Running (prod environment)
Execute `docker-compose -f docker-compose.yml -f docker-compose.remote.yml up -d`

### Running (dev environment) - do not use for the first run
1.  Run `docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml up -d`
2.  Check with `docker-compose ps` that all containers `Running`
3.  Open <http://localhost:3000> to check if Magento is started

For more details please refer to [Development environment](./E-development-environment.md) section.
