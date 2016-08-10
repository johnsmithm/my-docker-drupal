FROM             ubuntu:14.04
MAINTAINER       Mosnoi Ion <moshnoi2000@gmail.com>

ENV REFRESHED_AT=2016-01-12 \
    #PROXY=http://proxy.example.ch:80 \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get -qqy update && \
    dpkg-divert --local --rename --add /sbin/initctl && \
    ln -sf /bin/true /sbin/initctl  

# Additional base packages
# More later: software-properties-common php5-memcache memcached ruby-compass 
RUN apt-get -qy install git vim-tiny curl wget pwgen \
  mysql-client mysql-server \
  apache2 libapache2-mod-php5 php5-mysql php5-gd php5-curl \
  python-setuptools && \
  apt-get -q autoclean

# Install drush

RUN sudo apt-get install drush -y
RUN sudo drush dl drush --destination='/usr/share' 

#todo: drush is not upgraded! install docker with composer or set up the option 1 by default


# Sample backup script
ADD ./backup.sh  /root/backup.sh
# Webfactory specifc
ADD ./webfact_rm_site.sh /tmp/.webfact_rm_site.sh

# ENV variables
# (note: ENV is one long line to minimise layers)
ENV \
  # Make sure we have a proper working terminal
  TERM=xterm 

 # Setup a default postfix to allow local delivery and stop drupal complaining
#  for external delivery add local config to custom.sh such as:
#  postconf -e 'relayhost = myrelay.example.ch'
RUN apt-get install -q -y postfix
ADD ./postfix.sh /opt/postfix.sh
RUN chmod 755 /opt/postfix.sh

### Custom startup scripts
RUN easy_install supervisor

#ADD ../. /var/www/html
ADD ./start.sh /start.sh
ADD ./settings.php /tmp/settings.php
ADD ./000-default.conf /etc/apache2/sites-available/000-default.conf
ADD ./foreground.sh /etc/apache2/foreground.sh
ADD ./supervisord.conf /etc/supervisord.conf
ADD ./supervisord.d    /etc/supervisord.d

ADD ./aliases.drushrc.php   /tmp/aliases.drushrc.php

VOLUME ["/var/www/html", "/tmp/drupal"]

WORKDIR /var

RUN chmod 755 /start.sh /etc/apache2/foreground.sh
EXPOSE 80
CMD ["/bin/bash", "/start.sh"]