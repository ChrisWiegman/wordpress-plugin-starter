DOCKER_RUN				:= @docker run --rm
COMPOSER_BASE_CONTAINER	:= -v $$(pwd):/app --user $$(id -u):$$(id -g) composer
NODE_IMAGE 				:= -w /home/node/app -v $$(pwd):/home/node/app --user node wpnode
HAS_LANDO 				:= $(shell command -v lando 2> /dev/null)
CURRENTUSER				:= $$(id -u)
CURRENTGROUP			:= $$(id -g)

.PHONY: build
build: build-assets

.PHONY: build-assets
build-assets: | build-docker-node
	@echo "Building plugin assets"
	rm -f plugin/languages/*.pot plugin/scripts/*-min.js
	$(DOCKER_RUN) $(NODE_IMAGE) ./node_modules/gulp-cli/bin/gulp.js

.PHONY: build-docker
build-docker: build-docker-node build-docker-php

.PHONY: build-docker-node
build-docker-node:
	if [ ! "$$(docker images | grep wpnode)" ]; then \
		echo "Building the Node image"; \
		docker build \
			-f Docker/Dockerfile-node \
			--build-arg UID=$(CURRENTUSER) \
			--build-arg GID=$(CURRENTUSER) \
			-t wpnode .; \
	fi

.PHONY: build-docker-php
build-docker-php:
	if [ ! "$$(docker images | grep wpunit)" ]; then \
		echo "Building the PHP image"; \
		docker build -f Docker/Dockerfile-php -t wpunit .; \
	fi

.PHONY: clean
clean: stop clean-assets clean-build

.PHONY: clean-assets
clean-assets:
	@echo "Cleaning up plugin assets"
	rm -rf plugin/languages/*.pot  plugin/scripts/*-min.js

.PHONY: clean-build
clean-build:
	@echo "Cleaning up build-artifacts"
	rm -rf node_modules wordpress build vendor clover.xml

.PHONY: install
install: | clean-assets clean-build
	$(MAKE) install-composer
	$(MAKE) install-npm
	$(MAKE) build-assets

.PHONY: install-composer
install-composer:
	$(DOCKER_RUN) $(COMPOSER_BASE_CONTAINER) install

.PHONY: install-npm
install-npm: | build-docker-node
	$(DOCKER_RUN) $(NODE_IMAGE) npm install

.PHONY: lando-start
lando-start:
ifdef HAS_LANDO
	if [ ! -d ./wordpress/ ]; then \
		$(MAKE) install; \
	fi
	if [ ! "$$(docker ps | grep wordpresspluginstarter_appserver)" ]; then \
		echo "Starting Lando"; \
		lando start; \
	fi
	if [ ! -f ./wordpress/wp-config.php ]; then \
		$(MAKE) setup-wordpress; \
		$(MAKE) setup-wordpress-plugins; \
	fi
endif

.PHONY: lando-stop
lando-stop:
ifdef HAS_LANDO
	if [ "$$(docker ps | grep wordpresspluginstarter_appserver)" ]; then \
		echo "Stopping Lando"; \
		lando stop; \
	fi
endif

.PHONY: setup-wordpress
setup-wordpress:
	@echo "Setting up WordPress"
	lando wp config create --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost=database --path=./wordpress
	lando wp core install --path=./wordpress --url=https://wordpress-plugin-starter.lndo.site --title="WordPress Plugin Development" --admin_user=admin --admin_password=password --admin_email=contact@chriswiegman.com

.PHONY: setup-wordpress-plugins
setup-wordpress-plugins:
	lando wp plugin install --path=./wordpress debug-bar --activate
	lando wp plugin install --path=./wordpress query-monitor --activate

.PHONY: start
start: lando-start

.PHONY: stop
stop: lando-stop

.PHONY: test
test: test-lint test-unit

.PHONY: test-lint
test-lint: test-lint-php test-lint-javascript

.PHONY: test-lint-javascript
test-lint-javascript: | build-docker-node
	@echo "Running JavaScript linting"
	$(DOCKER_RUN) $(NODE_IMAGE) ./node_modules/jshint/bin/jshint

.PHONY: test-lint-php
test-lint-php:
	@echo "Running PHP linting"
	./vendor/bin/phpcs --standard=./phpcs.xml

.PHONY: test-unit
test-unit: | build-docker-php
	@echo "Running Unit Tests Without Coverage"
	docker run -v $$(pwd):/app --rm wpunit /app/vendor/bin/phpunit

.PHONY: test-unit-coverage
test-unit-coverage: | build-docker-php
	@echo "Running Unit Tests With Coverage"
	docker run -v $$(pwd):/app --rm --user $$(id -u):$$(id -g) wpunit /app/vendor/bin/phpunit  --coverage-text --coverage-html build/coverage/

.PHONY: update-composer
update-composer:
	$(DOCKER_RUN) $(COMPOSER_BASE_CONTAINER) update

.PHONY: update-npm
update-npm:
	$(DOCKER_RUN) $(NODE_IMAGE) npm update
