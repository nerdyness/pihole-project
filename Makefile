CONTAINER=dyndns

.PHONY: help
help: ## Prints this help/overview message
	@echo "Don't forget to set CONTAINER= with make run"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {targets[NR]=$$1; help[NR]=$$2; if(length($$1)>max) max=length($$1)} END {for(i=1;i<=NR;i++) if(targets[i]) printf "\033[36m%"max"s >\033[0m %s\n", targets[i], help[i]}' $(MAKEFILE_LIST)

.PHONY: start
start: ## Start all containers
	docker compose up -d

.PHONY: stop
stop: ## Stop all containers
	docker compose down

.PHONY: run
run: ## Run a single CONTAINER via docker-compose
	docker compose up -d $(CONTAINER)

.PHONY: cron
cron: ## Links the ./cron file to /etc/cron.d/containers
	sudo ln -sf $$PWD/cron /etc/cron.d/containers
	tail /var/log/syslog

.PHONY: clean
clean: ## Cleans up old docker images
	docker image prune
