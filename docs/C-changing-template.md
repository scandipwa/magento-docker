# Changing variables
All service versions are stored and taken from variables, independently configurable for each environment.
For global changes in services (enable, disable, add), you should edit `docker-compose.yml`.

For specific environment edits, like port mapping, file sharing etc, you should not edit `docker-compose.yml`, and 
work on environment specific overwrites, eg: `docker-compose.local.yml`.
See [Template structure overview](02-structure-overview.md) for more details.

Two types of variable configuration is used:

## ARG

These perameters are set and used for building application container, changed in the `.env` file, the default values set in Dockerfile and persisted via ENV with the same name.

When you change any ARG parameter, you need to rebuild container, test it, and push changes to the repo.

## ENV

This set of parameters are used in application and service runtime, couple of them are set in `.env`, and the rest in the `.application`

When those settings are changed, you need to recreate the needed container.



#### Reference  
<https://vsupalov.com/docker-arg-env-variable-guide/> - complete guide and description about ARG/ENV usage in docker/docker-compose
<https://docs.docker.com/compose/compose-file/> - full docker-compose.yml reference
<https://docs.docker.com/compose/env-file/> - docker-compose .env usage
