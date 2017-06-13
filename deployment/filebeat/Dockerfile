FROM phusion/baseimage
LABEL maintainer "Stefan Bratic <cobrijani@gmail.com>"

ENV REFRESHED_AT 2017-05-23


###############################################################################
#                                INSTALLATION
###############################################################################

ENV FILEBEAT_VERSION 5.4.1
ENV BEAT_NAME GENERIC_BEAT


RUN apt-get update -qq \
 && apt-get install -qqy curl \
 && apt-get clean

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-amd64.deb \
 && dpkg -i filebeat-${FILEBEAT_VERSION}-amd64.deb \
 && rm filebeat-${FILEBEAT_VERSION}-amd64.deb

###############################################################################
#                                CONFIGURATION
###############################################################################

# config file
ADD filebeat.yml /etc/filebeat/filebeat.yml
RUN chmod 644 /etc/filebeat/filebeat.yml

# CA cert
RUN mkdir -p /etc/pki/tls/certs \
 && mkdir -p /etc/pki/tls/private

ADD ./cryptography/certs/ca/ca.pem /etc/pki/tls/certs/ca.pem
ADD ./cryptography/certs/beats/beats.pem /etc/pki/tls/certs/beats.pem
ADD ./cryptography/certs/beats/beats.key /etc/pki/tls/private/beats.key

# ADD Template
ADD filebeat.template.json /usr/share/filebeat/filebeat.template.json

###############################################################################
#                                    START
###############################################################################

ADD wait.sh /wait.sh
RUN chmod +x /wait.sh
ADD start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
CMD [ "/usr/local/bin/start.sh" ]
