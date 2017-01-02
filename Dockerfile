FROM linode/lamp
MAINTAINER Kevin Porras <kporras07@gmail.com>

RUN apt-get update -y
RUN apt-get install -y build-essential curl wget git php5-curl unzip php5-mysql php5-gd ssh-client openssh-client keychain
RUN eval `ssh-agent`
RUN wget -q https://deb.nodesource.com/setup_4.x
RUN chmod +x setup_4.x
RUN ./setup_4.x
RUN rm setup_4.x
RUN apt-get install nodejs -y
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer
RUN composer global require drush/drush:8.x-dev --no-interaction
RUN mkdir -p ~/.drush
RUN curl https://github.com/pantheon-systems/terminus/releases/download/0.11.0/terminus.phar -L -o /usr/local/bin/terminus && chmod +x /usr/local/bin/terminus
CMD ["/bin/bash"]
