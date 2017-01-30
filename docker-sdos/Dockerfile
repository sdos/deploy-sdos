#	Project MCM
#
#	Copyright (C) <2015-2017> Tim Waizenegger, <University of Stuttgart>
#
#	This software may be modified and distributed under the terms
#	of the MIT license.  See the LICENSE file for details.

FROM ubuntu:latest
MAINTAINER Tim Waizenegger <tim.waizenegger@ipvs.uni-stuttgart.de>

RUN apt-get update
RUN apt-get install -y python3-pip git
RUN mkdir /mcm
WORKDIR /mcm
RUN git clone https://github.com/timwaizenegger/mcm-sdos.git
WORKDIR mcm-sdos
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

COPY sdos.sh /mcm
COPY configuration.py /mcm/mcm-sdos/mcm/sdos/

EXPOSE 8000

ENTRYPOINT ["/mcm/sdos.sh"]