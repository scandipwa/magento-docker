# Define available commands
.PHONY: build full-rebuild push up recreate down frontend-up frontend-down frontend-build \
 down-rm-volumes applogs logs flushall

# Warning! Do not use soft tabs!
up:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml up -d

build:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml build

down:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml down --remove-orphans

down-rm-volumes:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml down -v

applogs:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml logs -f app

logs:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml logs -f

full-rebuild:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.ssl.yml -f docker-compose.frontend.yml build --pull --no-cache

flushall:
	docker-compose -f docker-compose.yml -f docker-compose.local.yml exec varnish varnishadm "ban req.url ~ /"
	docker-compose -f docker-compose.yml -f docker-compose.local.yml exec redis redis-cli FLUSHALL