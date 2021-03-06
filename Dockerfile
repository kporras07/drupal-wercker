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
RUN ln -s ~/.composer/vendor/bin/drush /usr/bin/drush
RUN curl https://github.com/pantheon-systems/terminus/releases/download/0.11.2/terminus.phar -L -o /usr/local/bin/terminus && chmod +x /usr/local/bin/terminus
# Selenium support.
RUN apt-get install xvfb -y
RUN mkdir -p $HOME/google-chrome && cd $HOME/google-chrome && curl -L -o google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i $HOME/google-chrome/google-chrome.deb ; apt-get update -y ; apt-get install -f -y
RUN wget https://chromedriver.storage.googleapis.com/2.28/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN ln -s $PWD/chromedriver /usr/bin/chromedriver
RUN apt-get install software-properties-common python-software-properties -y
RUN add-apt-repository ppa:openjdk-r/ppa -y
RUN apt-get update -y
RUN apt-get install openjdk-8-jdk -y
RUN wget http://selenium-release.storage.googleapis.com/3.0/selenium-server-standalone-3.0.1.jar
RUN xvfb-run java -jar selenium-server-standalone-3.0.1.jar > /dev/null 2>&1 &
# Wraith support.
RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN \curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles
RUN /bin/bash -c "source /usr/local/rvm/scripts/rvm \
    && rvm install 2.4 \
    && rvm use 2.4 \
    && gem install wraith"
RUN apt-get install libicu-dev imagemagick rake -y
RUN npm install -g casperjs phantomjs
CMD ["/bin/bash"]
