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
sudo apt update
sudo apt dist-upgrade
sudo apt install -y screen python3-pip git docker.io htop tpm-tools libtspi-dev libopencryptoki-dev libssl-dev

A=$(whoami)
sudo usermod -a -G docker $A

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

docker exec -it mcm_nodered \
npm install node-red-node-sqlite node-red-contrib-postgres

docker restart mcm_nodered


echo ">>>>>>MCM deploy>>>>>>>> start kafka message broker"
docker run -d --name mcm_kafka \
--network sdos-net --ip="172.18.0.33" \
--env ADVERTISED_HOST="172.18.0.33" \
--env ADVERTISED_PORT=9092 \
spotify/kafka



echo ">>>>>>MCM deploy>>>>>>>> start ceph object store"
docker run --name mcm_ceph -d \
--network sdos-net --ip="172.18.0.22" \
-v /mnt________:/var/lib/ceph \
-v /etc/ceph:/etc/ceph \
-e MON_IP=172.18.0.22 \
-e CEPH_PUBLIC_NETWORK=172.18.0.0/24 \
-e CEPH_DEMO_UID="sdos" \
-e CEPH_DEMO_ACCESS_KEY="passw0rd" \
-e CEPH_DEMO_SECRET_KEY="passw0rd" \
ceph/demo

docker exec -it cephtest radosgw-admin subuser create --uid=sdos --subuser=sdos:user --access=full
docker exec -it cephtest radosgw-admin key create --subuser=sdos:user --key-type=swift --gen-secret



echo
echo
echo
echo ">>>>>>MCM deploy>>>>>>>> deploying docker containers for MCM services"
cd docker-sdos
docker build . -t mcm/sdos
cd

docker run --name mcm_sdos -d \
--network sdos-net --ip="172.18.0.11" \
mcm/sdos


cd docker-bluebox
docker build . -t mcm/bluebox
cd

docker run --name mcm_bluebox -d \
--network sdos-net --ip="172.18.0.100" \
mcm/bluebox


cd docker-extractor
docker build . -t mcm/extractor
cd

docker run --name mcm_extractor -d \
--network sdos-net --ip="172.18.0.200" \
mcm/extractor


exit

echo
echo
echo
echo ">>>>>>MCM deploy>>>>>>>> All done!"
