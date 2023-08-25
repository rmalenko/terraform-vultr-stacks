#!/bin/bash

# Follows https://docs.docker.com/engine/security/https/

DOCKER_DAEMON_HOSTNAME="${1}"
DOCKER_DAEMON_IP="${2}"
KEY_PASSWORD=digitalsilk

[ -z "${DOCKER_DAEMON_HOSTNAME}" ] && echo "Usage: $0 DOCKER_DAEMON_HOSTNAME" && exit 1

set -e

# Server certs
openssl genrsa -aes256 -out ca-key.pem -passout "pass:${KEY_PASSWORD}" 4096 

echo -e "[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
C=US
ST=NY
L=New York
O=DigitalSilk
OU=DevOps
emailAddress=devops@digitalsilk.com
CN = ${DOCKER_DAEMON_HOSTNAME}" > docker.cnf

openssl req -passin "pass:${KEY_PASSWORD}" -new -x509 -days 3650 -key ca-key.pem -sha256 -out ca.pem -config docker.cnf
openssl genrsa -passout "pass:${KEY_PASSWORD}" -out server-key.pem 4096
openssl req -passin "pass:${KEY_PASSWORD}" -subj "/CN=${DOCKER_DAEMON_HOSTNAME}" -sha256 -new -key server-key.pem -out server.csr
echo "subjectAltName = DNS:${DOCKER_DAEMON_HOSTNAME},IP:${DOCKER_DAEMON_IP},IP:127.0.0.1" > extfile.cnf
echo "extendedKeyUsage = serverAuth" >> extfile.cnf
openssl x509 -passin "pass:${KEY_PASSWORD}" -req -days 3650 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem \
    -CAcreateserial -out server-cert.pem -extfile extfile.cnf

# Client auth
openssl genrsa -out key.pem -passout "pass:${KEY_PASSWORD}" 4096
openssl req -passin "pass:${KEY_PASSWORD}" -subj '/CN=client' -new -key key.pem -out client.csr
echo "extendedKeyUsage = clientAuth" > extfile-client.cnf
openssl x509 -passin "pass:${KEY_PASSWORD}" -req -days 3650 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem \
    -CAcreateserial -out cert.pem -extfile extfile-client.cnf

# Cleanup
rm -f client.csr server.csr extfile.cnf extfile-client.cnf docker.cnf

mv ca.pem ca-key.pem server-cert.pem server-key.pem /etc/docker/
#mv ca.pem ca-key.pem server-cert.pem server-key.pem /etc/docker/
chmod -v 0400 /etc/docker/ca-key.pem /etc/docker/server-key.pem

mkdir -p ~/.docker/
cp /etc/docker/ca.pem ~/.docker/
mv key.pem cert.pem ~/.docker/

# Add SystemD drop-in
mkdir -p /etc/systemd/system/docker.service.d/
echo -e "[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --tlsverify --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server-cert.pem --tlskey=/etc/docker/server-key.pem -H=0.0.0.0:2376" > /etc/systemd/system/docker.service.d/10-expose-api-tls.conf
systemctl daemon-reload
systemctl restart docker
