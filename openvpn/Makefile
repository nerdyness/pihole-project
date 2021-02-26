IMAGE_NAME=openvpn
DOCKER_VOLUME=ovpn-data-volume
TAG=latest
CMD=docker run --volume $(DOCKER_VOLUME):/etc/openvpn
VPN_HOST=tcp://vpn.krist.tech:443
USERNAME=sk
SHELL:=/bin/bash

.PHONY: help
help: ## Prints this help/overview message
	@echo "   **Don't forget to set USERNAME=user when you run add-user**"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-13s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: build
build: ## Rebuild the docker image
	docker build -t $(IMAGE_NAME):$(TAG) ./docker-openvpn

.PHONY: run
run: ## Run a container from the latest image
	$(CMD) -d -p 443:1194/tcp --cap-add=NET_ADMIN $(IMAGE_NAME):$(TAG)

.PHONY: add-user
add-user: ## Adds a new user to the CA and dumps their ovpn config.
	$(CMD) --rm -it $(IMAGE_NAME):$(TAG) easyrsa build-client-full $(USERNAME) nopass
	make get-user-config

.PHONY: get-user-config
get-user-config: ## Fetches the USERNAME's ovpn config and dumps it in ./
	$(CMD) --rm -it $(IMAGE_NAME):$(TAG) ovpn_getclient $(USERNAME) > $(USERNAME).ovpn
	echo -e "\ndata-ciphers AES-256-GCM:AES-128-GCM\ndata-ciphers-fallback AES-256-CBC" >> $(USERNAME).ovpn # Add cipher to ovpn file
	sed -i -e 's/\r//' $(USERNAME).ovpn # Remove DOS-style line endings

.PHONY: debug
debug: ## Run a container and drop into a bash
	$(CMD) --rm -it $(IMAGE_NAME):$(TAG) /bin/bash

.PHONY: initial-setup
initial-setup: ## Run this first to create the docker volume and config
	docker volume create --name $(DOCKER_VOLUME)
	$(CMD) --rm $(IMAGE_NAME):$(TAG) ovpn_genconfig -u $(VPN_HOST)
	$(CMD) --rm -it $(IMAGE_NAME):$(TAG) ovpn_initpki

# .SILENT:
