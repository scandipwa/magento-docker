# Frontend container

As ScandiPWA consists of 2 almos separate applications, at least we can treat them this way, 
it is important to keep development environment up to date with the tools, that can bump up the effectivity.
At the same time - environment must be able to mirror a production-like environment. For these reasons, we have 
created a plug&play `frontend` container, that is easily pluggable and meant to be used in *development environment 
only*. 

## How to run
Simply add one more file (`-f docker-compose.frontend.yml`) to you docker-compose command, to include proper nginx 
overrides and run `frontend` container.
At any time recreate the environment without `docker-compose.frontend.yml` to get production-like environment.

## What's inside
Inside frontend container is a simple nodejs environment with webpack dev server compiling and serving frontend
application. It grants much faster compilation and clientside application serving.

## What to note
The basepath is the same as for `app` container and is set to `/var/www/public`, however, it has
only theme folder mounted inside, as `frontend` container has nothing to do with Magento files, Composer etc.
*By default `app/design/frontend/Scandiweb/pwa` is mounted inside*. In case you need to work with a theme located in 
other path - you have to adjust the mounting point in `/docker-compose.frontend.yml` line 14:
**Default**:

`- ./src/app/design/frontend/Scandiweb/pwa:/var/www/public`

**Customized example**:

`- ./src/app/design/frontend/*vendor*/*my-awesome-theme*:/var/www/public` 

Unless mounted folder contains valid theme (`npm ci && npm run watch` are executed correctly) - container will 
keep failing with an NPM error and stacktrace.
