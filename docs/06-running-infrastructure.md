# Running the infrastructure

Apart of building images, the way containers are started is very important, as port mapping (networking), file mounting or even parameter override can occur when container is running.

For insfrastracture management, including it's starting behaviour and settings modification options we decided to 
utilize docker-compose wrapper.

Docker-compose by default is working with docker-compose.yml file only. For details on different docker-compose files
 please refer to: [Structure overview](02-structure-overview.md)
 
**Do not change `docker-compose.yml` until you are not adding/removing or changing a default service behavior for ALL
 environments.**

## Directory mapping, port mapping, image
In order you want to run alternative image, map to different port or mount/unmount specific directory `docker-compose
.<environment>.yml` is the right place to start. Feel free to update according to your needs, however, once you see 
`${variable_name}` in the yml file - it is better to edit a prover env files (symlinked to /.env). For more details 
on the env files please refer to [Structure overview](02-structure-overview.md?id=symlinks)

Due to some limitation, you should create some folders manually (for Linux only).
 Create folder for additional mount points (workaround for Linux):
`mkdir -p src/var src/generated src/pub/static src/static`

## Raising up the unfrastructure
In order to use multiple *yml config files*, you must explicitly define all of them, for example:

`docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d`

Such command will follow simple logic:
1) read docker-compose.yml
2) **extend** container configuration with docker-compose.local.yml definitions

When containers are created, they are automatically prefixed with current directory name by default.
Additionaly, by passing `-p` flag, you can isolate them within the namespace:

In example: `docker-compose -f docker-compose.yml -f docker-compose.remote.yml -p prefix up -d`
will raise the same infrastructure within the virtual Docker-compose project, called by the prefix.
In order to reach any of containers over docker-compose, you must always follow up your command with `-p` project 
command, for example:

`docker-compose ps` - will show the status of the first example


**Please note** Mounting behaviour might seems not to follow this logic, however, that is only caused by mounting 
nature itself. Apparently you can not mount (bind) more then one volume and/or directory to the same path. Only the latest rule will take affect.

**Please note** Using `-p` flag does not solve port mapping issue, when the same infrastructures can not be runned 
at the same time.


## Command execution
Since all services are defined within the `docker-compose.yml` you do not have to execute each command with multiple 
`-f` flags, but for initial *up*, that requires all the additional setting to mount and map properly by default.

Using the docker-compose CLI, it is not necessary to remember or look for a full container name, it is enough to pass
 the service name, as per *docker-compose* files.
 Let's consider an example:
 
 `docker-compose logs -f app` - open and follow logs from the `app` service (defined in *docker-compose.yml*).
 
 `docker-compose exec app bash` - execute *bash* command on `app` service, automatically passing -it flags.
 
 `docker-compose restart varnish` - restart `varnish` service.
 
 Alternatively, you can use pure Docker commands. Examples ordered accordingly to previous:
 
 `docker logs -f docke-template_app_1` or `docker logs -f <ae608296f86c>`
 
 `docker exec -it docker-template_app_1 bash` or `docker exec -it <ae608296f86c> bash`
 
 `docker restart docker-template_varnish_1` or `docker restart <69f693c855dc>`

Where `docker-template_app_1` and `docker-template_varnish_1` are container names, and should not
 be relied on, while  `69f693c855dc` and `ae608296f86c` are container IDs specific for the runtime, and must never be 
 relied on.
