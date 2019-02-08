FROM linode/lamp
MAINTAINER Kevin Porras <kporras07@gmail.com>

RUN apt-get update -y
RUN apt-get install software-properties-common -y
RUN apt-get install python-software-properties -y
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update -y
RUN apt-get install -y --force-yes build-essential curl wget git php5.6-cli php5.6-curl unzip php-mysql php5.6-mysql php5.6-gd ssh-client openssh-client keychain php5.6-gd php5.6-mbstring php5.6-common php5.6-xml
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
RUN ln -s ~/.composer/vendor/bin/drush /usr/bin/drush
RUN curl -O https://raw.githubusercontent.com/pantheon-systems/terminus-installer/master/builds/installer.phar && php installer.phar install
# Selenium support.
RUN apt-get install xvfb -y
RUN mkdir -p $HOME/google-chrome && cd $HOME/google-chrome && curl -L -o google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i $HOME/google-chrome/google-chrome.deb ; apt-get update -y ; apt-get install -f -y
RUN wget https://chromedriver.storage.googleapis.com/2.28/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN ln -s $PWD/chromedriver /usr/bin/chromedriver
RUN add-apt-repository ppa:openjdk-r/ppa -y
RUN apt-get update -y
RUN apt-get install openjdk-8-jdk -y
RUN wget http://selenium-release.storage.googleapis.com/3.0/selenium-server-standalone-3.0.1.jar
RUN xvfb-run java -jar selenium-server-standalone-3.0.1.jar > /dev/null 2>&1 &
# Wraith support.
CMD ["/bin/bash"]
