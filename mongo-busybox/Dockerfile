FROM mongoclient/mongoclient
WORKDIR /busybox
COPY . ./
CMD ["./wait-for-it.sh", "mongo:27017", "-- mongo --host mongo -u memphis -p memph1smong0 --authenticationDatabase admin" ]
