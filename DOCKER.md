# Docker template for ScandiPWA based on Magento ^2.3

Detailed docs are available in [docs](docs.scandipwa.com) folder

## Composer Authentification

For `COMPOSER_AUTH` use your personal Magento 2 key from marketplace. [More info here](https://docs.scandipwa.com/#/docker/A-requirements.md).

## Host environment variables must be set

```bash
export COMPOSER_AUTH='{"http-basic":{"repo.magento.com": {"username": "REPLACE_THIS", "password": "REPLACE_THIS"}}}'
```

## Quick start

1.  Requirements are met, see above
2.  Clone repository and cd to it
3.  `composer.json` must be present in `/src`
4.  Run `docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d`
5.  Check with `docker-compose ps` that all containers `Running`
6.  Open <http://localhost:3000> to check if Magento is started

### Troubleshooting

#### See the debug

If something does not work, like you see 404 when opening the site.

1.  Run docker without the `-d` -> `docker-compose -f docker-compose.yml -f docker-compose.local.yml up`
2.  Check logs of running containers by executing: `docker-compose logs -f`

#### Container exited exited with code 1

If you see error like this
```console
[Composer\Downloader\TransportException]                                   
app_1      |   The 'https://repo.magento.com/packages.json' URL required authentication.  
app_1      |   You must be using the interactive console to authenticate
```

It means your `COMPOSER_AUTH` has wrong credentials. 

Please ensure that the keys are correct and that you ran the `export` command in **the same terminal window** as you 
run the `docker-compose`

#### Issues with directory permissions

Make sure you can run docker without `sudo`. See [Manage Docker as a non-root user](https://docs.docker.com/install/linux/linux-postinstall/)

#### Can't get into bash in the container

If you see error like this
```bash
$ docker-compose exec -u user app bash -l
unable to find user user: no matching entries in passwd file
``` 
there is an issue with your `app` container.

1.  Make sure you have latest version of the docker
2.  (Optional, if previous versions exists on your machine) Run `docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml build`
3.  Start containers with `--force-recreate` like this `docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml up --force-recreate`
