#	Project MCM
#
#	Copyright (C) <2015-2017> Tim Waizenegger, <University of Stuttgart>
#
#	This software may be modified and distributed under the terms
#	of the MIT license.  See the LICENSE file for details.

FROM ubuntu:latest
MAINTAINER Tim Waizenegger <tim.waizenegger@ipvs.uni-stuttgart.de>

RUN apt-get update
RUN apt-get install -y python3-pip
RUN mkdir /mcm
RUN cd /mcm
RUN git clone https://github.com/timwaizenegger/mcm-sdos.git
RUN cd mcm-sdos
RUN pip install -r requirements.txt
RUN cp mcm/sdos/configuration.example.py mcm/sdos/configuration.py

EXPOSE 8000

ENTRYPOINT ["python /mcm/mcm-sdos/_runService_Production.py"]