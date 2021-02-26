CONTAINER=dyndns

.PHONY: help
help: ## Prints this help/overview message
	@echo "Don't forget to set CONTAINER= with make run"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-13s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: start
start: ## Start all containers
	docker-compose up -d

.PHONY: stop
stop: ## Stop all containers
	docker-compose down

.PHONY: run
run: ## Run a single CONTAINER via docker-compose
	docker-compose up -d $(CONTAINER)

.PHONY: cron
cron: ## Links the ./cron file to /etc/cron.d/containers
	sudo ln -sf $$PWD/cron /etc/cron.d/containers
