#	Project MCM
#
#	Copyright (C) <2015-2017> Tim Waizenegger, <University of Stuttgart>
#
#	This software may be modified and distributed under the terms
#	of the MIT license.  See the LICENSE file for details.

FROM python:3.6
MAINTAINER Tim Waizenegger <tim.waizenegger@ipvs.uni-stuttgart.de>


RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y nodejs yarn

RUN mkdir /mcm
WORKDIR /mcm
RUN git clone https://github.com/timwaizenegger/mcm-bluebox.git
WORKDIR mcm-bluebox
RUN pip install -r requirements.txt
WORKDIR mcm/Bluebox/angular
RUN yarn install
WORKDIR /mcm/mcm-bluebox
RUN cp mcm/Bluebox/configuration.example.py mcm/Bluebox/configuration.py

COPY bluebox.sh /mcm

EXPOSE 8000

ENTRYPOINT ["/mcm/bluebox.sh"]