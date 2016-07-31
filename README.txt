This repository contain a docker setup for drupal sites.
It download the drupal files from git and link the database with parameters from run command.
Drupal uses an external database.

DEPLOY DEVELOPMENT SITE:

0.Install docker on your machine!
1.Clone the repository
2.Go to that repository
3.Change the parameters in the run.sh command(database,username of the database, password, hostname)
4.In order to run the container with standard setup:
	sudo ./run.sh

In order to visi the site go to: http:localhost:8003/
In order to edit files go to /tmp/data 

SYNC CHANGES WITH PRODUCTION
1. commit/push changes to github
2. sync database with production database using drush(not configured yet)


Install Docker on ubuntu 12
add docker update link to list of ubuntu updates
sudo apt-get update
sudo apt-get install docker-engine
sudo apt-get install docker.io #not sure, not needed