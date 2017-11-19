# Drupal - Composer - Docker

Docker image with out-of-box support for Composer workflow. Recommanded Composer template: https://github.com/drupal-composer/drupal-project

- [Composer](https://getcomposer.org) is pre-installed
- CLI utilities installed by Composer (Drush, Drupal Console, ...) are in PATH, so you can call them from anywhere in the container
- Drush [will know](https://github.com/iBobik/drupal-composer-docker/blob/master/drushrc.php#L4) where is Drupal root, so you do not have to be in the project directory
- DocumentRoot is in /var/www/drupal/web, so Drupal is in subdirectory of project root (/var/www/drupal - where composer.json is located).

## Tags
Tags of this image follow `apache` tags of [drupaldocker/php image](https://hub.docker.com/r/drupaldocker/php/).

It uses GitLab CI and it's registry, so **you have to prepend image by: `registry.gitlab.com`** You can use also [Docker Hub](https://hub.docker.com/r/bobik/drupal-composer), but there is only `7.1-apache` tag, because Docker Hub does not support scripting in build process.

Available tags can be seen on [GitLab project page](https://gitlab.com/janpoboril/drupal-composer-docker/container_registry).

## How to use it

Pull and run image by CLI:
```
docker run -d -p 8080:80 --name my-drupal-app -v $(pwd)/drupal:/var/www/drupal registry.gitlab.com/janpoboril/drupal-composer-docker:7.1-apache
```
or better use in `docker-compose.yml` like:
```
services:
  web:
    image: registry.gitlab.com/janpoboril/drupal-composer-docker:7.1-apache
    ports:
      - "8080:80"
    volumes:
      - ./web/drupal:/var/www/drupal
```
or as a base for your own image in `Dockerfile` beginning with:
```
FROM registry.gitlab.com/janpoboril/drupal-composer-docker:7.1-apache
```

### Initializing Drupal project

This image does not contain Drupal code, so you have many options how to use it. Recommended way how to initialize new project by Composer:

Open shell into container:
```
docker exec -it -u www-data myproject_web_1 bash
```
And clone template (you should be in `~/drupal` - default working directory):
```
composer create-project drupal-composer/drupal-project:8.x-dev . --stability dev --no-interaction
```

Then Drupal is ready to run in browser or install modules by Composer:
```
composer require drupal/devel:~1.0
```
See [template's README](https://github.com/drupal-composer/drupal-project) for more examples how to use it.

**Warning about Drush and Console:** Current versions does not understand projects where Drupal is in a subdirectory (composer.json and index.php are not siblings), so if you try to download a module by them (e.g. `drush dl devel` including `drush en devel`) they will not use Composer but will use "old-school http tar.gz" method (module will not be recorded into composer.json).
