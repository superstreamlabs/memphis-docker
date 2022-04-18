#!/bin/sh
docker network create memphis

docker run -d --network memphis -p 27017:27017 --name mongo -e MONGO_INITDB_ROOT_USERNAME=memphis -e MONGO_INITDB_ROOT_PASSWORD=memph1smong0 mongo:4.2

docker run -d --name memphis-cluster -p 7766:4222 -p 6222:6222 -p 8222:8222 nats -js --auth=memphis
docker run -d --network memphis -p 5555:5555 -p 8877:8877 -e ROOT_PASSWORD=memphis -e CONNECTION_TOKEN=memphis --name control-plane memphisos/memphis-control-plane:0.1
docker run -d --network memphis -p 9000:80 --name memphis-ui memphisos/memphis-ui:0.1
docker run -it --rm --network memphis mongo:4.2 mongo --host mongo -u memphis -p memph1smong0 --authenticationDatabase admin --eval 'db.createUser({user: "memphis", pwd: "memph1smong0", roles:[{role: "userAdmin" , db:"maindb"}]})'



bash -c "while true; do mongo --host mongo -u memphis -p memph1smong0 --authenticationDatabase admin --eval 'db.createUser({user: "memphis", pwd: "memph1smong0", roles:[{role: "userAdmin" , db:"maindb"}]})'; done"
