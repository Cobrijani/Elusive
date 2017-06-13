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


 ### install Kibana

ENV KIBANA_VERSION 5.4.1
ENV KIBANA_HOME /opt/kibana
ENV KIBANA_PACKAGE kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz
ENV KIBANA_GID 993
ENV KIBANA_UID 993

RUN mkdir ${KIBANA_HOME} \
 && curl -O https://artifacts.elastic.co/downloads/kibana/${KIBANA_PACKAGE} \
 && tar xzf ${KIBANA_PACKAGE} -C ${KIBANA_HOME} --strip-components=1 \
 && rm -f ${KIBANA_PACKAGE} \
 && groupadd -r kibana -g ${KIBANA_GID} \
 && useradd -r -s /usr/sbin/nologin -d ${KIBANA_HOME} -c "Kibana service user" -u ${KIBANA_UID} -g kibana kibana \
 && mkdir -p /var/log/kibana \
 && chown -R kibana:kibana ${KIBANA_HOME} /var/log/kibana \
 && .${KIBANA_HOME}/bin/kibana-plugin install x-pack
ADD ./kibana-init /etc/init.d/kibana
RUN sed -i -e 's#^KIBANA_HOME=$#KIBANA_HOME='$KIBANA_HOME'#' /etc/init.d/kibana \
 && chmod +x /etc/init.d/kibana


###############################################################################
#                               CONFIGURATION
###############################################################################

ADD ./cryptography/certs/ca/ca.pem /etc/pki/tls/certs/ca.pem
ADD ./cryptography/certs/elusive-1/elusive-1.pem /etc/pki/tls/certs/elusive-1.pem
ADD ./cryptography/certs/kibana/kibana.key /etc/pki/tls/private/kibana.key
ADD ./cryptography/certs/kibana/kibana.pem /etc/pki/tls/cert/kibana.pem

### configure logrotate
ADD ./kibana-logrotate /etc/logrotate.d/kibana
RUN  chmod 644 /etc/logrotate.d/kibana


###############################################################################
#                                   START
###############################################################################

ADD ./wait.sh /usr/local/bin/wait.sh
RUN chmod +x /usr/local/bin/wait.sh
ADD ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 5601

CMD [ "/usr/local/bin/start.sh" ]
