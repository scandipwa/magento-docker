# Define available commands
.PHONY: cert

# Variables
current_dir := $(shell pwd)
uid := $(shell id -u)
gid := $(shell id -g)

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
