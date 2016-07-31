#!/bin/bash

docker build -t v1.1 .

docker stop v1.1
docker rm v1.1
#docker run -td -p 8009:80 -v /tmp/data:/var/www/html  --name  v1.1 v1.1
docker run -td -p 8003:80 -e "MYSQL_ROOT_PASSWORD=psw"  -e "MYSQL_USER=username"  -e "MYSQL_DATABASE=db"  -e "MYSQL_HOST=host"  -v /tmp/data:/var/www/html --name v1.1 v1.1 
docker logs -f v1.1
#docker run -ti v1.1 /bin/bash
