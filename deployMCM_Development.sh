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