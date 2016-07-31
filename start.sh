#!/bin/bash

echo "01. setup apache"
mkdir /var/log/apache2 2>/dev/null
chown -R www-data /var/log/apache2 2>/dev/null
a2enmod rewrite vhost_alias headers
a2ensite 000-default

mkdir -p /var/lib/drupal-private
chown -R www-data /var/lib/drupal-private

GIT_REPO="https://github.com/johnsmithm/drupal.the.docker.git"
#MYSQL_HOST=""
#MYSQL_USER=""
#MYSQL_DATABASE=""
#MYSQL_ROOT_PASSWORD=""
MYSQL_PASSWORD="1"

#todo: handle existing repository

echo "02. cloning repo"
cd /var/www
rm -rf html
git clone ${GIT_REPO} html
cd html
mkdir -p sites/default/files && chmod 755 sites/default && chown -R www-data:www-data sites/default/files;

echo "03. setting database"
mv /tmp/settings.php sites/default/settings.php
sed -i "s/placeholder_PWD/${MYSQL_ROOT_PASSWORD}/g" sites/default/settings.php
sed -i "s/placeholder_DB/${MYSQL_DATABASE}/g" sites/default/settings.php
sed -i "s/placeholder_USER/${MYSQL_USER}/g" sites/default/settings.php
sed -i "s/placeholder_HOST/${MYSQL_HOST}/g" sites/default/settings.php
   
# Create log that can be written to in the running container, and visible in the
# docker log (stdout) and thus the webfact UI.
# todo: could this be done by supervisord, but it must send the tail to stdout?
webfactlog=/tmp/webfact.log;
echo "`date '+%Y-%m-%d %H:%M'` Create new $webfactlog" > $webfactlog
tail -f $webfactlog &

# Start any stuff in rc.local
echo "-- starting /etc/rc.local"
/etc/rc.local &

echo "4. Starting processes via supervisor."
# Start lamp, make sure no PIDs lying around
rm /var/run/apache2/apache2.pid /var/run/rsyslog.pid /var/run/rsyslogd.pid /var/run/mysqld/mysqld.pid /var/run/crond.pid 2>/dev/null 2>/dev/null
supervisord -c /etc/supervisord.conf -n
