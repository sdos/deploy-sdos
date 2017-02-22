#	Project MCM
#
#	Copyright (C) <2015-2017> Tim Waizenegger, <University of Stuttgart>
#
#	This software may be modified and distributed under the terms
#	of the MIT license.  See the LICENSE file for details.



FROM nodered/node-red-docker:latest
MAINTAINER Tim Waizenegger <tim.waizenegger@ipvs.uni-stuttgart.de>

RUN npm install node-red-contrib-postgres

COPY files/flows_mcm-bluebox.json /data/flows.json

CMD ["npm", "start", "--", "--userDir", "/data"]