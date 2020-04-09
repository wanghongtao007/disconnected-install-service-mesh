#!/bin/bash 

yum -y install podman httpd httpd-tools

mkdir -p /haozhao/registry/{auth,certs,data}

cd /haozhao/registry/certs && openssl req -newkey rsa:4096 -nodes -sha256 -keyout domain.key -x509 -days 365 -out domain.crt

htpasswd -bBc /haozhao/registry/auth/htpasswd admin redhat

podman run -td --name internal-registry -p 5000:5000 \
-v /haozhao/registry/data:/var/lib/registry:z \
-v /haozhao/registry/auth:/auth:z \
=======
mkdir -p /home/opregistry/{auth,certs,data}

cd /home/opregistry/certs && openssl req -newkey rsa:4096 -nodes -sha256 -keyout domain.key -x509 -days 365 -out domain.crt

htpasswd -bBc /home/opregistry/auth/htpasswd admin redhat

podman run -td --name internal-registry -p 5000:5000 \
-v /home/opregistry/data:/var/lib/registry:z \
-v /home/opregistry/auth:/auth:z \
-e "REGISTRY_AUTH=htpasswd" \
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry" \
-e "REGISTRY_HTTP_SECRET=ALongRandomSecretForRegistry" \
-e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
-v /haozhao/registry/certs:/certs:z \
-v /home/opregistry/certs:/certs:z \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
-e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
docker.io/library/registry:2

