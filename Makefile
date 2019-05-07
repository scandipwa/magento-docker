# Define available commands
.PHONY: build full-rebuild push up recreate down cert pull \
 down-rm-volumes applogs logs flushall

# Variables
current_dir := $(shell pwd)
uid := $(shell id -u)
gid := $(shell id -g)

# Warning! Do not use soft tabs!
up:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml up -d

build:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml build

pull:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml pull

down:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml down --remove-orphans

down-rm-volumes:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml down -v

applogs:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml logs -f app

logs:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml logs -f

full-rebuild:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml build --pull --no-cache

flushall:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml exec varnish varnishadm "ban req.url ~ /"
	docker-compose -f docker-compose.yml -f docker-compose.local.yml exec redis redis-cli FLUSHALL

cert:
	mkdir -p opt/cert
	docker run -it --rm --init \
	-e UID=$(uid) \
	-e GID=$(gid) \
	-w="/cert" \
	--mount type=bind,source=$(current_dir)/deploy/shared/conf/local-ssl,target=/cert_config/ \
	--mount type=bind,source=$(current_dir)/opt/cert,target=/cert \
	--mount type=bind,source=$(current_dir)/deploy/create_certificates.sh,target=/usr/local/bin/create_certificates \
	alpine:latest create_certificates
