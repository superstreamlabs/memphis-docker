#! /bin/bash

### Variables ###
STATUS=TRUE
# Array of mandatory expressions in docker-compose file

array=( DOCKER_ENV: true ROOT_PASSWORD: memphis CONNECTION_TOKEN: memphis )

# For loop that validate each expression in array
for i in "${array[@]}"
do
  if [[ "$(cat docker-compose.yml)" != *"$i"*  ]]; then
    echo $i
    STATUS=FALSE
  fi
done

for i in "${array[@]}"
do
  if [[ "$(cat docker-compose-latest.yml)" != *"$i"*  ]]; then
    echo $i
    STATUS=FALSE
  fi
done

if [[ $STATUS == FALSE ]]; then
  exit 1
fi
