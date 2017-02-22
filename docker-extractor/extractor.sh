#!/bin/bash
#	Project MCM
#
#	Copyright (C) <2015-2017> Tim Waizenegger, <University of Stuttgart>
#
#	This software may be modified and distributed under the terms
#	of the MIT license.  See the LICENSE file for details.

cd /mcm/mcm-metadataExtractor/
git pull
export PYTHONPATH=$PYTHONPATH:/mcm/mcm-metadataExtractor/mcm


python _runListener.py
