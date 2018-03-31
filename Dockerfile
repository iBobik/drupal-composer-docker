ARG  BASE_IMAGE_TAG=7.2-apache
FROM drupaldocker/php:${BASE_IMAGE_TAG}

# Install CLI dependencies
RUN apt-get update && apt-get install -y mariadb-client curl git vim \
	&& apt-get clean

# Install Composer
RUN echo "allow_url_fopen = On" > /usr/local/etc/php/conf.d/drupal-01.ini
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin -- --filename=composer

# Create directories for Drupal
RUN mkdir -p /tmp/drupal && chown www-data:www-data /tmp/drupal
RUN chown www-data:www-data /var/www
WORKDIR /var/www/drupal

# Config
ENV DOCROOT=/var/www/drupal/web
ADD apache.conf /etc/apache2/sites-enabled/000-default.conf
ADD bashrc.sh /var/www/.bashrc
ADD drushrc.php /etc/drush/drushrc.php
