#!/bin/bash
#	Project MCM
#
#	Copyright (C) <2015-2017> Tim Waizenegger, <University of Stuttgart>
#
#	This software may be modified and distributed under the terms
#	of the MIT license.  See the LICENSE file for details.

cd /mcm/mcm-bluebox/
git pull
export PYTHONPATH=$PYTHONPATH:/mcm/mcm-sbluebox/mcm

pip install -r requirements.txt
cd mcm/Bluebox/angular
npm install
cd ../../../


# run as a flask multithread app
python _runApp_Development.py

# pyKafka messaging doesn't work right on gunicorn...
# only use this if you don't need the message view
# ./_runApp_Production.sh
