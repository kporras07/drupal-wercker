FROM php:7.1-apache
MAINTAINER Kevin Porras <kporras07@gmail.com>

# Miscellaneous.
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential curl wget git unzip ssh-client openssh-client keychain mysql-server
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libpng-dev zlib1g-dev
RUN docker-php-ext-install -j$(nproc) pdo pdo_mysql gd zip
RUN mkdir /var/run/mysqld
RUN chown -R mysql:root /var/run/mysqld
RUN service mysql start && mysql -u root -e "create database drupal; " && mysql -u root -e "SET PASSWORD FOR root@'localhost' = PASSWORD('root');"

# SSH
RUN eval `ssh-agent`
RUN mkdir -p /root/.ssh/
RUN echo 'Host *' >> /root/.ssh/config
RUN echo '   StrictHostKeyChecking no' >> /root/.ssh/config

# Nodejs
RUN wget -q https://deb.nodesource.com/setup_8.x
RUN apt-get install -y gnupg
RUN chmod +x setup_8.x
RUN ./setup_8.x
RUN rm setup_8.x
RUN DEBIAN_FRONTEND=noninteractive apt-get install nodejs -y

# Ahoy
RUN wget -q https://github.com/ahoy-cli/ahoy/releases/download/2.0.0/ahoy-bin-linux-amd64 -O /usr/local/bin/ahoy && chmod +x /usr/local/bin/ahoy

# Composer and terminus
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer
RUN composer global require drush/drush:8.x-dev --no-interaction
RUN mkdir -p ~/.drush
RUN ln -s ~/.composer/vendor/bin/drush /usr/bin/drush
RUN curl -O https://raw.githubusercontent.com/pantheon-systems/terminus-installer/master/builds/installer.phar && php installer.phar install

COPY ./php.ini /usr/local/etc/php/conf.d/docker-php.ini
COPY cmd.sh ./cmd.sh
RUN chmod +x cmd.sh
CMD ["./cmd.sh"]
