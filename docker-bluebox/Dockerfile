#	Project MCM
#
#	Copyright (C) <2015-2017> Tim Waizenegger, <University of Stuttgart>
#
#	This software may be modified and distributed under the terms
#	of the MIT license.  See the LICENSE file for details.

FROM ubuntu:latest
MAINTAINER Tim Waizenegger <tim.waizenegger@ipvs.uni-stuttgart.de>

RUN apt-get update
RUN apt-get dist-upgrade -y

RUN apt-get install -y npm nodejs-legacy python3-pip git libpq-dev librdkafka1
RUN pip3 install --upgrade pip


RUN mkdir /mcm
WORKDIR /mcm
RUN git clone https://github.com/timwaizenegger/mcm-bluebox.git
WORKDIR mcm-bluebox
RUN cp mcm/Bluebox/configuration.example.py mcm/Bluebox/configuration.py

COPY bluebox.sh /mcm

EXPOSE 8000

ENTRYPOINT ["/mcm/bluebox.sh"]