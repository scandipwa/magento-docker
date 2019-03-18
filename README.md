# Welcome to ScandiPWA

This repository is a base repository that contains Docker environment for Magento ^2.3 and is dedicated for ScandiPWA
 theme development and ScandiPWA based project development.
 
## Docker
Please refer to [Docker](./DOCKER.md) and documentation [docs](./docs/)

## Modularity
The repository is based on Magento 2.3.0. All components and modules, except the further theme development must be 
managed by [Composer](https://getcomposer.org)

## Dependencies
- [scandipwa/installer](https://github.com/scandipwa/installer)
- [scandipwa/source](https://github.com/scandipwa/base-theme)
- [scandipwa/graphql](https://github.com/scandipwa/graphql)
- [scandipwa/catalog-graphql](https://github.com/scandipwa/catalog-graphql)
- [scandipwa/cms-graphql](https://github.com/scandipwa/cms-graphql)
- [scandipwa/menu-organizer](https://github.com/scandipwa/menu-organizer)
- [scandipwa/persisted-query](https://github.com/scandipwa/persisted-query)
- [scandipwa/slider-graphql](https://github.com/scandipwa/slider-graphql)
- [scandipwa/slider](https://github.com/scandipwa/slider)
- [scandiweb/module-core](https://github.com/scandiwebcom/Scandiweb-Assets-Core)

## Quick start
1. Make sure [requirements](docs/A-requirements.md) are met
2. Clone the repository
```console
git clone git@github.com:scandipwa/scandipwa-base.git
```
3. Set `COMPOSER_HOME` on your machine (you can obtain credentials using [Magento2 Marketplace](https://account.magento.com/applications/customer/login/))
```console
export COMPOSER_AUTH='{"http-basic":{"repo.magento.com": {"username": "REPLACE_THIS", "password": "REPLACE_THIS"}}}'
```
4. Run the infrastructure 
```console
docker-compose up -d
```

> **NOTICE**: Do the following steps only in case you need ScandiPWA DEMO

5. Stop the application container 
```console
docker-compose stop app
```
6. Recreate existing database 
```console
docker-compose exec mysql mysql -u root -pscandipwa -e "DROP DATABASE magento; CREATE DATABASE magento;"
```
7. Import DEMO ScandiPWA database: 
```console
docker-compose exec -T mysql mysql -u root -pscandipwa magento < deploy/latest.sql
```
8. Recreate Docker infrastructure
```console
docker-compose up -d --force-recreate
```
