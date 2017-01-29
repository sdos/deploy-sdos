#!/bin/bash
#	Project MCM
#
#	Copyright (C) <2015-2017> Tim Waizenegger, <University of Stuttgart>
#
#	This software may be modified and distributed under the terms
#	of the MIT license.  See the LICENSE file for details.


export PYTHONPATH=$PYTHONPATH:/mcm/mcm-sdos/mcm

python3 /mcm/mcm-sdos/_runService_Production.py
