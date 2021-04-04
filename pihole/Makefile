CONTAINER_NAME=pihole
NETWORK=containers_default
RUN_DIR=..

.PHONY: help
help: ## Prints this help/overview message
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-13s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: run
run: ## Run a container from the latest image
	docker run --rm \
	           --network $(NETWORK) \
		   --env-file $(RUN_DIR)/.env.$(IMAGE_NAME) \
	   	   $(IMAGE_NAME):$(TAG)

.PHONY: debug
debug: ## Run a container and drop into a bash
	docker exec -it $(CONTAINER_NAME) /bin/bash
