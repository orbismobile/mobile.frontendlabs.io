.DEFAULT_GOAL := help

hugo: ## hugo command, Use: make hugo
	/bin/sh ./hugo.sh

newpost: ## newpost command, Use: make newpost name=my_url
	#@echo $(filter-out $@,$(MAKECMDGOALS))
	/bin/sh .scripts/newpost.sh $(name)

command: ## exec bash command
	docker-compose exec hugo sh -c "hugo new posts/$(filter-out $@,$(MAKECMDGOALS)).md"

up: ## Up services Production
	docker-compose up

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
