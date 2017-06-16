FROM phusion/baseimage

LABEL maintainer "Stefan Bratic <cobrijani@gmail.com>"

###############################################################################
#                                INSTALLATION
###############################################################################

### install prerequisites (cURL, gosu, JDK)

ENV GOSU_VERSION 1.8

ARG DEBIAN_FRONTEND=noninteractive
RUN set -x \
 && apt-get update -qq \
 && apt-get install -qqy --no-install-recommends ca-certificates curl \
 && rm -rf /var/lib/apt/lists/* \
 && curl -L -o /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
 && curl -L -o /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
 && export GNUPGHOME="$(mktemp -d)" \
 && gpg --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
 && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
 && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
 && chmod +x /usr/local/bin/gosu \
 && gosu nobody true \
 && apt-get update -qq \
 && apt-get install -qqy openjdk-8-jdk \
 && apt-get clean \
 && set +x


ENV LOGSTASH_VERSION 5.4.1
ENV LOGSTASH_HOME /opt/logstash
ENV LOGSTASH_PACKAGE logstash-${LOGSTASH_VERSION}.tar.gz
ENV LOGSTASH_GID 992
ENV LOGSTASH_UID 992

RUN mkdir ${LOGSTASH_HOME} \
 && curl -O https://artifacts.elastic.co/downloads/logstash/${LOGSTASH_PACKAGE} \
 && tar xzf ${LOGSTASH_PACKAGE} -C ${LOGSTASH_HOME} --strip-components=1 \
 && rm -f ${LOGSTASH_PACKAGE} \
 && groupadd -r logstash -g ${LOGSTASH_GID} \
 && useradd -r -s /usr/sbin/nologin -d ${LOGSTASH_HOME} -c "Logstash service user" -u ${LOGSTASH_UID} -g logstash logstash \
 && mkdir -p /var/log/logstash /etc/logstash/conf.d \
 && chown -R logstash:logstash ${LOGSTASH_HOME} /var/log/logstash

ADD ./logstash-init /etc/init.d/logstash
RUN sed -i -e 's#^LS_HOME=$#LS_HOME='$LOGSTASH_HOME'#' /etc/init.d/logstash \
 && chmod +x /etc/init.d/logstash

### Install logstash plugins
RUN .${LOGSTASH_HOME}/bin/logstash-plugin install logstash-filter-grok \
 && .${LOGSTASH_HOME}/bin/logstash-plugin install logstash-filter-date \
 && .${LOGSTASH_HOME}/bin/logstash-plugin install x-pack
###############################################################################
#                               CONFIGURATION
###############################################################################


RUN mkdir -p /etc/pki/tls/jks

### Add certificates and private keys
ADD ./cryptography/certs/ca/ca.pem /etc/pki/tls/certs/ca.pem
ADD ./cryptography/certs/elusive-1/elusive-1.pem /etc/pki/tls/certs/elusive-1.pem
ADD ./cryptography/certs/logstash/logstash.pem /etc/pki/tls/certs/logstash.pem
ADD ./cryptography/certs/logstash/logstash.key /etc/pki/tls/private/logstash.key
ADD ./cryptography/certs/logstash/logstash.pkcs8 /etc/pki/tls/private/logstash.pkcs8
ADD ./cryptography/jks/logstash-keystore.jks /etc/pki/tls/jks/logstash-keystore.jks
ADD ./cryptography/jks/logstash-truststore.jks /etc/pki/tls/jks/logstash-truststore.jks



ADD ./logstash-logrotate /etc/logrotate.d/logstash
RUN chmod 644 /etc/logrotate.d/logstash


ADD ./wait.sh /usr/local/bin/wait.sh
RUN chmod +x /usr/local/bin/wait.sh
ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 5044
CMD [ "/usr/local/bin/start.sh" ]

