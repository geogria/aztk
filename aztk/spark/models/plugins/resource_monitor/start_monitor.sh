#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

if  [ "$AZTK_IS_MASTER" = "1" ]; then
    echo "Create docker containers"
    sudo docker-compose up --no-start
    echo "Run the containers"
    sudo docker-compose start
else
    AZTK_IS_MASTER=0
fi

echo "Install telegraf"
curl -sL https://repos.influxdata.com/influxdb.key | apt-key add -
source /etc/lsb-release
echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | tee /etc/apt/sources.list.d/influxdb.list

echo "BATCH_NODE_ID=$BATCH_NODE_ID" > /etc/default/telegraf

echo "Run telegraf"
apt-get update && sudo apt-get install telegraf
telegraf --config ./etc/telegraf.conf &
