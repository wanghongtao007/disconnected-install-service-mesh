#!/bin/bash 

DATE=$(date +%Y-%m-%d-%H:%M:%S)

function log(){
    echo "$DATE INFO $@"
    return 0
}

function panic(){
    echo "$DATE ERROR $@"
    exit 1
}

if [ $# -lt 1 ]; then
    panic  "Usage: $0 Destination directory"
fi

DESTDIR=$1

images=(
registry.redhat.io/distributed-tracing/jaeger-agent-rhel7:1.13.1
registry.redhat.io/distributed-tracing/jaeger-all-in-one-rhel7:1.13.1
registry.redhat.io/distributed-tracing/jaeger-collector-rhel7:1.13.1
registry.redhat.io/distributed-tracing/jaeger-ingester-rhel7:1.13.1
registry.redhat.io/distributed-tracing/jaeger-es-index-cleaner-rhel7:1.13.1
registry.redhat.io/distributed-tracing/jaeger-query-rhel7:1.13.1
registry.redhat.io/distributed-tracing/jaeger-rhel7-operator:1.13.1
registry.redhat.io/openshift-service-mesh/kiali-rhel7:1.0.12
registry.redhat.io/openshift-service-mesh/kiali-rhel7-operator:1.0.12
registry.redhat.io/openshift-service-mesh/citadel-rhel8:1.0.10
registry.redhat.io/openshift-service-mesh/galley-rhel8:1.0.10
registry.redhat.io/openshift-service-mesh/grafana-rhel8:1.0.10
registry.redhat.io/openshift-service-mesh/istio-cni-rhel8:1.0.10
registry.redhat.io/openshift-service-mesh/istio-rhel8-operator:1.0.10
registry.redhat.io/openshift-service-mesh/mixer-rhel8:1.0.10
registry.redhat.io/openshift-service-mesh/pilot-rhel8:1.0.10
registry.redhat.io/openshift-service-mesh/prometheus-rhel8:1.0.10
registry.redhat.io/openshift-service-mesh/proxyv2-rhel8:1.0.10
registry.redhat.io/openshift-service-mesh/sidecar-injector-rhel8:1.0.10
registry.redhat.io/openshift4/ose-elasticsearch-operator:latest
registry.redhat.io/openshift4/ose-logging-elasticsearch5:latest
registry.redhat.io/openshift4/ose-oauth-proxy:latest
registry.redhat.io/openshift4/ose-oauth-proxy:4.2
docker.io/maistra/examples-bookinfo-details-v1:0.12.0
docker.io/maistra/examples-bookinfo-productpage-v1:0.12.0
docker.io/maistra/examples-bookinfo-ratings-v1:0.12.0
docker.io/maistra/examples-bookinfo-reviews-v1:0.12.0
docker.io/maistra/examples-bookinfo-reviews-v2:0.12.0
docker.io/maistra/examples-bookinfo-reviews-v3:0.12.0
quay.io/jaysonzhao/svcmeshcodeready:latest
registry.redhat.io/codeready-workspaces/server-rhel8:2.0
registry.redhat.io/codeready-workspaces/server-operator-rhel8:2.0
registry.redhat.io/codeready-workspaces/devfileregistry-rhel8:2.0
registry.redhat.io/redhat-sso-7/sso73-openshift:1.0-15
registry.redhat.io/codeready-workspaces/pluginregistry-rhel8:2.0
registry.redhat.io/rhscl/postgresql-96-rhel7:1-47
registry.access.redhat.com/rhscl/mysql-57-rhel7
registry.access.redhat.com/rhscl/redis-32-rhel7
quay.io/redhat/quay:v3.2.0
quay.io/redhat/quay:v3.2.1
quay.io/redhat/clair-jwt:v3.2.0
quay.io/redhat/clair-jwt:v3.2.1
docker.io/library/postgres
docker.io/wangzheng422/quay-fs:3.2.0-init
quay.io/jaysonzhao/redhat-operators:v2
quay.io/jaysonzhao/svcmeshcodeready:latest
quay.io/jaysonzhao/community-operators:v2
registry.redhat.io/codeready-workspaces/server-operator-rhel8:2.0
registry.redhat.io/codeready-workspaces/server-rhel8:2.0
registry.redhat.io/codeready-workspaces/pluginregistry-rhel8:2.0
registry.redhat.io/codeready-workspaces/devfileregistry-rhel8:2.0
registry.redhat.io/codeready-workspaces/pluginbroker-rhel8:2.0
registry.redhat.io/codeready-workspaces/pluginbrokerinit-rhel8:2.0
registry.redhat.io/codeready-workspaces/jwtproxy-rhel8:2.0
registry.redhat.io/codeready-workspaces/machineexec-rhel8:2.0
registry.redhat.io/codeready-workspaces/theia-rhel8:2.0
registry.redhat.io/codeready-workspaces/theia-endpoint-rhel8:2.0
registry.redhat.io/rhscl/postgresql-96-rhel7:1-47
registry.redhat.io/redhat-sso-7/sso73-openshift:1.0-15
registry.redhat.io/ubi8-minimal:8.0-213
registry.redhat.io/codeready-workspaces/stacks-cpp-rhel8:2.0
registry.redhat.io/codeready-workspaces/stacks-dotnet-rhel8:2.0
registry.redhat.io/codeready-workspaces/stacks-golang-rhel8:2.0
registry.redhat.io/codeready-workspaces/stacks-java-rhel8:2.0
registry.redhat.io/codeready-workspaces/stacks-node-rhel8:2.0
registry.redhat.io/codeready-workspaces/stacks-php-rhel8:2.0
registry.redhat.io/codeready-workspaces/stacks-python-rhel8:2.0
registry.redhat.io/codeready-workspaces/plugin-openshift-rhel8:2.0
quay.io/jmckind/argocd-operator@sha256:5d7c4b0e8e0fea068e49a9718a35ae068fc267e607f7393374db39916d7186f4
argoproj/argocd@sha256:f7a4a8e4542ef9d2e0cb6d3fe5814e87b79b8064089c0bc29ae7cefae8e93b66
quay.io/dexidp/dex@sha256:c14ea9dbf341de51c8c0858a65bfe905a0a2cc154311c959a0bfe609bfe177b5v2.21.0
redis@sha256:4be7fdb131e76a6c6231e820c60b8b12938cf1ff3d437da4871b9b2440f4e385
)

for image in ${images[@]}; do
	src=$image
	dst=${DESTDIR}/${image##*/}.tar	
	podman pull $src
	podman save $src > $dst
done
