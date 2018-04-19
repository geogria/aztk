#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose

cd $DIR

echo "InfluxDB password is $INFLUXDB_USER_PASSWORD"
echo "InfluxDB password is $GF_SECURITY_ADMIN_PASSWORD"

# Install pip requirements
echo "Install pip requirements"
#sudo chmod 777 requirements.txt
pip3 install -r requirements.txt

if  [ "$AZTK_IS_MASTER" = "1" ]; then
    echo "Create the database and grafana containers"
    sudo docker-compose up --no-start
    echo "Run the containers"
    sudo docker-compose start
else
    AZTK_IS_MASTER=0
fi

echo "Run nodestats in background"
touch nodestats.out
#chmod 777 nodestats.out
python3 nodestats.py > nodestats.out 2>&1 $AZTK_MASTER_IP $AZTK_IS_MASTER $AZ_BATCH_POOL_ID $AZ_BATCH_NODE_ID &
