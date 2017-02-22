#	Project MCM
#
#	Copyright (C) <2015-2017> Tim Waizenegger, <University of Stuttgart>
#
#	This software may be modified and distributed under the terms
#	of the MIT license.  See the LICENSE file for details.

FROM python:3.6
MAINTAINER Tim Waizenegger <tim.waizenegger@ipvs.uni-stuttgart.de>


RUN mkdir /mcm
WORKDIR /mcm
RUN git clone https://github.com/timwaizenegger/mcm-metadataExtractor.git
WORKDIR mcm-metadataExtractor
RUN pip install -r requirements.txt
RUN cp mcm/metadataExtractor/configuration.example.py mcm/metadataExtractor/configuration.py


COPY extractor.sh /mcm

ENTRYPOINT ["/mcm/extractor.sh"]