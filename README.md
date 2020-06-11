# WordPress Plugin Starter

A starter plugin to get you going quickly with a new WordPress plugin.

## What's included

* WordPress
* Debug Bar
* Query Monitor
* PHP 7.4
* Mailhog
* Starter plugin files
* Starter PHP Unit Tests
* Configuration, including Xdebug, for VSCode
* Linting for PHP and JavaScript files using WordPress coding standards

## Developing a real plugin with this code

Developing a real plugin with this code is easy.

First, rename all appropriate instances of the my name (Chris Wiegman) and the starter plugin name (wordpress-plugin-starter) throughout the codebase. For now, you'll want to do this manually as the case and spacing character can differ upon usage.

All plugin source code should go in the _plugin_ folder. This is what is mapped as the plugin in your test site. Classes should go into the _plugin/lib_ folder using any namespace as a subfolder. The plugin will automatically load all classes created in this fashion. See the autoloader in the main plugin file for more details.

All JavaScript files should go in the _plugin/scripts_ folder for sake of automatic minification.

While I plan to, at some point, setup a script that will handle renaming and more in the future, it just isn't there yet. Other planned improvements include using a more modern autoloader and switching off of Gulp.

## Setup and Usage of the Development Environment

A fully featured development environment is included using PHP 7.4 and more. Scripts to run commands including setup and more use _make_ as a task runner. See the instructions below for getting started.

Before starting your workstation will need the following:

* [Docker](https://www.docker.com/)
* [Lando](https://lando.dev/)

1. Clone the repository

`git clone https://gitea.chriswiegman.com/chriswiegman/wordpress-plugin-starter.git`

2. Start Lando

```bash
cd wordpress-plugin-starter
make start
```

When finished, Lando will give you the local URL of your site. You can finish the WordPress setup there.

WordPress Credentials:

__URL:__ _https://wordpress-plugin-starter.lndo.site/wp-admin_
__Admin User:__ _admin_
__Admin Password:__ _password

## Build and Testing

The plugin will build the .pot file for internationalization as well as minified versions of any JavaScript files:

```bash
make build
```

Note, assets will also build during the install phase.

The project uses the WP_Mock library for unit testing. Once setup run the following for unit tests:

```bash
make test-unit
```

We also use [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer) with [WordPress Coding Standards](https://github.com/WordPress/WordPress-Coding-Standards) and [JSHint](http://jshint.com/) with [WordPress' JS Standards](https://make.wordpress.org/core/handbook/best-practices/coding-standards/javascript/#installing-and-running-jshint). Linting will automagically be setup for you if you use [Visual Studio Code](https://code.visualstudio.com/). If you want to run it manually use the following:

```bash
make test-lint
```

or, to run an individual lint, use one of the following:

```bash
make test-lint-php
```

```bash
make test-lint-javascript
```

You can run all testing (all lints and unit tests) together with the following:

```bash
make test
```
