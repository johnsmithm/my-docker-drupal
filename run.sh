#!/bin/bash

PORT=8003
PWD=psw
USER=root
#dev1,dev2,life,stage
DB=dev1
HOST=1.1.1.1
NAME=v1.1

if [ "${DB}" = "dev1" ]; then
	PORT=8003
elif [[ "${DB}" = "dev2" ]]; then
	PORT=8005
elif [[ "${DB}" = "stage" ]]; then
	PORT=8002
elif [[ "${DB}" = "life" ]]; then
	PORT=8006
else 
	PORT=8003
fi

docker build -t ${NAME} .

docker stop ${NAME}
docker rm ${NAME}

docker run -td -p ${PORT}:80 -e "MYSQL_ROOT_PASSWORD=${PWD}"  -e "MYSQL_USER=${USER}" \
  -e "MYSQL_DATABASE=${DB}"  -e "MYSQL_HOST=${HOST}"  -v /tmp/${DB}:/var/www/html --name ${NAME} ${NAME}

docker logs -f ${NAME}

#docker run -ti ${NAME} /bin/bash
