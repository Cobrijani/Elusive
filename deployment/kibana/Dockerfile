FROM docker.elastic.co/kibana/kibana:5.4.1

LABEL maintainer "Stefan Bratic <cobrijani@gmail.com>"

ADD ./cryptography/certs/ca/ca.crt /etc/pki/tls/certs/ca.crt
ADD ./cryptography/certs/elusive-1/elusive-1.crt /etc/pki/tls/certs/elusive-1.crt
ADD ./cryptography/certs/kibana/k-key.pem /etc/pki/tls/private/kibana.key
ADD ./cryptography/certs/kibana/k-cert.pem /etc/pki/tls/cert/kibana.crt