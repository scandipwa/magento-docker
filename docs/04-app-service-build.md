# App service build

According to docker phylosophy, container is designed to run a single process. Following the phylosophy, app container is designed to run Magento (or other PHP application after the necessary changes are made) application.

Once you have properly built an image - with proper mounting it can be runned on any amount of servers, clouds, clusters without the differences.

**Important note:** application data, stored in temporary storages (varnish, redis) or database will not be automatically copied inside, because of service or application design. 

In order to run Magento, there are multiple actions required. Let's briefly go through the layers, that are applied during the build:

### Basic layer
Scandiweb pre-built m2fullstack image, please refer to [03-services](03-services.md) for details.

**Important notes:**

Any changes to the software below requires image rebuild.

Shell script changes might not be recognized by layer cache mechanism. To ensure new version is applied be encouraged
 to force empty cache on build, for example: `docker-compose build --no-cache app`
 
#### Basic layer updates
Template is still periodically updated, receiving improvements, fixes and new features. Some of the features, however, 
are distributed within the base image, that is built automatically and pulled in "as-is" state.

Meanwhile, Docker does not have built-in mechanism to implicitly check base image version, untill :<tag> is not changed
. Therefore, once you want to be sure or are asked to rebuild on the latest version, you must do one of the following
 actions:
 
1) Rebuild app service, forcing image pulling:

 ```docker-compose build --pull app```
 
These options are optional and require good understanding of versioning and stack used for the project, but are 100% valid scenarious:
 
2) Remove the existing image and rebuild the image normally:

```docker rmi scandipwa/scandipwa-base```

```docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d```
  
3) Pull the basic image:

```docker pull scandipwa/scandipwa-base:<version>```


**Note**:
Do not get confused by simple pulling, as this command will update only ready to use images, but won't recognize basic ("intermediate") ones, which are referenced within Dockerfile's:
```docker-compose -f docker-compose.yml -f docker-compose.local.yml pull```

### Dockerfile
Prepares the environment, according to defined parameters in .env and .application, including:
* copy source code from `./src` to `$BASEPATH` (defined in .env)
* php config copying
* helper tool installation
* running bootstrap.sh helper script (please see details below)
* preparing start.sh script for running (please refer to next section of the Docs)

## Bootstrap.sh
The main task of bootstrap.sh helper script is version control of additional tools.
Versions are defined in `.env` file symlinked to the `root folder` of the Docker-infrastructure.

Currently available for configuration binaries:
* Composer
* NodeJS
