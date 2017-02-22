#	Project MCM
#
#	Copyright (C) <2015-2017> Tim Waizenegger, <University of Stuttgart>
#
#	This software may be modified and distributed under the terms
#	of the MIT license.  See the LICENSE file for details.

FROM python:3.6
MAINTAINER Tim Waizenegger <tim.waizenegger@ipvs.uni-stuttgart.de>

#RUN apt-get updat
#RUN apt-get dist-upgrade -y
#RUN apt-get install -y python3-pip git tpm-tools libtspi-dev libopencryptoki-dev libssl-dev

RUN mkdir /mcm
WORKDIR /mcm
RUN git clone https://github.com/timwaizenegger/mcm-sdos.git
WORKDIR mcm-sdos
RUN cp mcm/sdos/configuration.example.py mcm/sdos/configuration.py

COPY sdos.sh /mcm

EXPOSE 3000

ENTRYPOINT ["/mcm/sdos.sh"]