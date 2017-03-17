#!/bin/bash
#	Project MCM
#
#	Copyright (C) <2015-2017> Tim Waizenegger, <University of Stuttgart>
#
#	This software may be modified and distributed under the terms
#	of the MIT license.  See the LICENSE file for details.

cd /metadata-extractor
git pull
export PYTHONPATH=$PYTHONPATH:/metadata-extractor


python _runListener.py
