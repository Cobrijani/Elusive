FROM phusion/baseimage
LABEL maintainer "Stefan Bratic <cobrijani@gmail.com>"

ENV REFRESHED_AT 2017-05-23


###############################################################################
#                                INSTALLATION
###############################################################################

ENV PACKETBEAT_VERSION 5.4.1
ENV BEAT_NAME PACKETBEAT


RUN apt-get update -qq \
 && apt-get install -qqy curl \
 && apt-get clean \
 && apt-get install -y --no-install-recommends \
      libpcap0.8


RUN curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-${PACKETBEAT_VERSION}-amd64.deb \
 && dpkg -i packetbeat-${PACKETBEAT_VERSION}-amd64.deb \
 && rm packetbeat-${PACKETBEAT_VERSION}-amd64.deb

###############################################################################
#                                CONFIGURATION
###############################################################################

# config file
# ADD packetbeat.yml /etc/packetbeat/packetbeat.yml
# RUN chmod 644 /etc/packetbeat/packetbeat.yml

# CA cert
RUN mkdir -p /etc/pki/tls/certs \
 && mkdir -p /etc/pki/tls/private

ADD ./cryptography/certs/ca/ca.pem /etc/pki/tls/certs/ca.pem
ADD ./cryptography/certs/beats/beats.pem /etc/pki/tls/certs/beats.pem
ADD ./cryptography/certs/beats/beats.key /etc/pki/tls/private/beats.key


###############################################################################
#                                    START
###############################################################################

ADD wait.sh /wait.sh
RUN chmod +x /wait.sh
ADD start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
CMD [ "/usr/local/bin/start.sh" ]
