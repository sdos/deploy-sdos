#!/usr/bin/env bash
#	Project MCM
#
#	Copyright (C) <2015-2017> <University of Stuttgart>
#
#	This software may be modified and distributed under the terms
#	of the MIT license.  See the LICENSE file for details.


echo ">>>>>>MCM deploy>>>>>>>> preparing environment"
cd
cp mcm-deployEnvironment/linux-conf/.* .
source .profile
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt dist-upgrade
sudo apt install -y npm nodejs-legacy screen python3-pip git daemontools libpq-dev librdkafka1 yarn docker.io htop tpm-tools libtspi-dev libopencryptoki-dev libssl-dev
pip3 install --upgrade pip
pip3 install --user virtualenv
A=$(whoami)
sudo usermod -a -G docker $A


echo
echo
echo
echo ">>>>>>MCM deploy>>>>>>>> deploying SDOS"
cd
git clone https://github.com/timwaizenegger/mcm-sdos.git
cd mcm-sdos
chmod +x run.sh
virtualenv venvSDOS
. setenv.sh
pip install -r requirements.txt
cp mcm/sdos/configuration.example.py mcm/sdos/configuration.py
deactivate


echo
echo
echo
echo ">>>>>>MCM deploy>>>>>>>> deploying metadataExtractor"
cd
git clone https://github.com/timwaizenegger/mcm-metadataExtractor.git
cd mcm-metadataExtractor
chmod +x run.sh
virtualenv venvME
. setenv.sh
pip install -r requirements.txt
cp mcm/metadataExtractor/configuration.example.py mcm/metadataExtractor/configuration.py
deactivate


echo
echo
echo
echo ">>>>>>MCM deploy>>>>>>>> deploying Bluebox"
cd
git clone https://github.com/timwaizenegger/mcm-bluebox.git
cd mcm-bluebox
chmod +x run.sh
virtualenv venvBB
. setenv.sh
pip install -r requirements.txt
cd mcm/Bluebox/angular
yarn install
cd ../../../
cp mcm/Bluebox/configuration.example.py mcm/Bluebox/configuration.py
deactivate


echo
echo
echo
echo ">>>>>>MCM deploy>>>>>>>> deploying Nodered"
cd
yarn add node-red-node-sqlite node-red-contrib-postgres node-red


echo
echo
echo
echo ">>>>>>MCM deploy>>>>>>>> deploying docker containers"
cd

echo ">>>>>>MCM deploy>>>>>>>> create network"
sudo -s

docker network create -d bridge --subnet 172.18.0.0/24 sdos-net


echo ">>>>>>MCM deploy>>>>>>>> start postgresql warehouse"
docker run -d --name mcm_warehouse \
--network sdos-net --ip="172.18.0.44" \
-p 5432:5432 \
--env POSTGRES_PASSWORD="passw0rd" \
postgres

docker exec -it mcm_warehouse psql -U postgres -c "create database mcm_metadata_mcmdemo;"


echo ">>>>>>MCM deploy>>>>>>>> start nodered analytics"
docker run -d --name mcm_nodered \
--network sdos-net --ip="172.18.0.55" \
nodered/node-red-docker



echo ">>>>>>MCM deploy>>>>>>>> start kafka message broker"
docker run -d --name mcm_kafka \
--network sdos-net --ip="172.18.0.33" \
--env ADVERTISED_HOST="172.18.0.33" \
--env ADVERTISED_PORT=9092 \
spotify/kafka



echo ">>>>>>MCM deploy>>>>>>>> start ceph object store"
docker run --name mcm_ceph -d \
--network sdos-net --ip="172.18.0.2" \
-v /mnt________:/var/lib/ceph \
-v /etc/ceph:/etc/ceph \
-e MON_IP=172.18.0.2 \
-e CEPH_PUBLIC_NETWORK=172.18.0.0/24 \
-e CEPH_DEMO_UID="sdos" \
-e CEPH_DEMO_ACCESS_KEY="passw0rd" \
-e CEPH_DEMO_SECRET_KEY="passw0rd" \
ceph/demo

docker exec -it cephtest radosgw-admin subuser create --uid=sdos --subuser=sdos:user --access=full
docker exec -it cephtest radosgw-admin key create --subuser=sdos:user --key-type=swift --gen-secret







exit

echo
echo
echo
echo ">>>>>>MCM deploy>>>>>>>> All done! configure the Swift backend in: $HOME/mcm-sdos/mcm/sdos/configuration.py"
echo ">>>>>>MCM deploy>>>>>>>> All done! then set the tenant-ID in: $HOME/mcm-metadataExtractor/mcm/metadataExtractor/configuration.py"
echo ">>>>>>MCM deploy>>>>>>>> Then start the services"
echo ">>>>>>MCM deploy>>>>>>>> SDOS: cd mcm-sdos; ./run.sh"
echo ">>>>>>MCM deploy>>>>>>>> Bluebox: cd mcm-bluebox; ./run.sh"
echo ">>>>>>MCM deploy>>>>>>>> Metadata Extractor: cd mcm-bluebox; ./run.sh"
echo ">>>>>>MCM deploy>>>>>>>> Nodered: cd mcm-deployEnvironment/nodered-runner; supervise ."
echo '>>>>>>MCM deploy>>>>>>>> Kafka: docker run -d --name mcm_broker -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST="localhost" --env ADVERTISED_PORT=9092 <ID>'
echo '>>>>>>MCM deploy>>>>>>>> Kafka: docker run -d --name mcm_warehouse -e POSTGRES_PASSWORD=testing -p 5432:5432 postgres'
