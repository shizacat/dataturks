#!/bin/bash

# create config file
envsubst < ${DATATURKS_CONF:=/home/dataturks/onprem.yml} > ./dataturks.conf

service apache2 start
echo "Staring Java App"
/usr/bin/java -Djava.net.useSystemProxies=true -server -jar dataturks-1.0-SNAPSHOT.jar server ./dataturks.conf &
sleep 7
#Run node app
cd bazaar
echo "Staring npm run start-onprem"
npm run start-onprem

while true; do sleep 1; done
