This repository contain a docker setup for drupal sites.
It download the drupal files from git and link the database with parameters from run command.
Drupal uses an external database.

In order to run the container with standard setup:
./run.sh

In order to visi the site go to: http:localhost:8003/

In order to change the database setting delete the database variable from start.sh and set them in the run command:
docker run -td -p 8003:80 -e "MYSQL_ROOT_PASSWORD=password" -v /tmp/data:/var/www/html --name v1.1 v1.1 

the parameter MYSQL_ROOT_PASSWORD was deleted in the start.sh file and added in the run command.
