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
registry.redhat.io/openshift-service-mesh/istio-rhel8-operator:1.1.2
registry.redhat.io/openshift-service-mesh/3scale-istio-adapter-rhel8@sha256:00fb544a95b16c652cc571396679c65d5889b2cfe6f1a0176f560a1678309a35
registry.redhat.io/openshift-service-mesh/citadel-rhel8@sha256:a49954528575c8480d6763e4793ab65de0f4c19ba5963544d57c91ededd63a90
registry.redhat.io/openshift-service-mesh/istio-cni-rhel8@sha256:b7b36d109847b11748442358178892d1e19ac121c920efe940f3b8dbc70ee28b
registry.redhat.io/openshift-service-mesh/galley-rhel8@sha256:620c85bdec44380711c00f189c4042f3a669eba2c089ca6cf9ae8ee5c4358121
registry.redhat.io/openshift-service-mesh/grafana-rhel8@sha256:f76e8bbd26c2bd474d55ce6378874fcb736e464aa0737ca22897a7b58b55661f
registry.redhat.io/openshift-service-mesh/mixer-rhel8@sha256:ad6ad158e647d11031d4478ed46bbabba83b4f66ba3a8068bd5ec82679511c5f
registry.redhat.io/openshift-service-mesh/pilot-rhel8@sha256:ebfc7f79d8c0cec52c6aac1727eee84f15c43a3d0f7b4503ae14d8ee6a8bd025
registry.redhat.io/openshift-service-mesh/prometheus-rhel8@sha256:70960efc418688d96d6e9b1ee8a35905ce221cb08d9e5aefff9616e44b95cd9f
registry.redhat.io/openshift-service-mesh/proxy-init-rhel7@sha256:7d14fc0fb52b7bf98427e9fb0cefbb3fd269e8a9341c2e17ba9cc347e53f73b8
registry.redhat.io/openshift-service-mesh/proxyv2-rhel8@sha256:e7813217b71b1004f7fcf5e212bf4f13ae7148f498860fb8b1e521a0147580ad
registry.redhat.io/openshift-service-mesh/sidecar-injector-rhel8@sha256:2f2361f4a0216fb3a2563b121ab7218e35af63114811683fc5c8e4889e999652
registry.redhat.io/openshift-service-mesh/3scale-istio-adapter-rhel8@sha256:00fb544a95b16c652cc571396679c65d5889b2cfe6f1a0176f560a1678309a35
registry.redhat.io/openshift-service-mesh/citadel-rhel8@sha256:d8ca7131c787087bba4ff4a805bfb691566cb8744837154a26401a5f284cedbd
registry.redhat.io/openshift-service-mesh/istio-cni-rhel8@sha256:b91b7890135b3e998a8d23650f7399093d1a6df7bc59edb609494f9bbedf3ac5
registry.redhat.io/openshift-service-mesh/galley-rhel8@sha256:2ea879cdf4e08bc53b09108106e5769046ff16983d8e6337a9cf3301cb3c5333
registry.redhat.io/openshift-service-mesh/grafana-rhel8@sha256:35a8fb6206216b01444e5fa31f4a15ccef42b254e0313ac640b2ebefb43a2de4
registry.redhat.io/openshift-service-mesh/ior-rhel8@sha256:0bf01756c8047ef8b7412b525b515daded05d80ac729c189552c7d849b8fc953
registry.redhat.io/openshift-service-mesh/mixer-rhel8@sha256:d41d9669b8c81f38d3c102d31d6e28535c64f3bbfb5233966112bbf9e5468dd0
registry.redhat.io/openshift-service-mesh/pilot-rhel8@sha256:d04c3ff0b16055acdbdb484061dfbf7fd201784c754a5eede3ca1f8f51ae5369
registry.redhat.io/openshift-service-mesh/prometheus-rhel8@sha256:68d47c477bb9b1a4cae6432361326efd0f75146ecf104c84b9c23afb09e77f09
registry.redhat.io/openshift-service-mesh/proxy-init-rhel7@sha256:5f4989ea6f73ad7056c8661584f1f134625e1cba884fec228648f5f2c4c021a0
registry.redhat.io/openshift-service-mesh/proxyv2-rhel8@sha256:37bf20d0b77587db4217ef38912e4f7527543602fe8c5b98b3c58de93d67ef8e
registry.redhat.io/openshift-service-mesh/sidecar-injector-rhel8@sha256:bd361cf4c1e37fe6a574821098c616b5543914ca8ae6de8f60889ced2008fe74
registry.redhat.io/openshift-service-mesh/istio-rhel8-operator@sha256:aee6bebfa43d80936f16fa3ce15b671e2102080d2677d0238790974c2aff8e8d

registry.redhat.io/distributed-tracing/jaeger-rhel7-operator@sha256:510ef9b390e25e12ce53cf26fb5405fddec24c9258c611982507a4164f5cd44b
registry.redhat.io/distributed-tracing/jaeger-agent-rhel7@sha256:6ad21491d876ddc6f0625169a3ba4526214906b28e6e051061016d8c63878a60
registry.redhat.io/distributed-tracing/jaeger-query-rhel7@sha256:e08ea8bc2410964f4fbecd239d3270628fe42ba2e5def5ab6927beec2e79addc
registry.redhat.io/distributed-tracing/jaeger-collector-rhel7@sha256:5f07ffb1dc5e91e2bd7b196ad83ba75c8fe9dcf033625e8da6f682da33956257
registry.redhat.io/distributed-tracing/jaeger-ingester-rhel7@sha256:9e9ef992dfe2b432cd3a603c1fcce5e9f490bc6d39abc832dc65070a86bdc56e
registry.redhat.io/distributed-tracing/jaeger-all-in-one-rhel7@sha256:393f42201ebd2239d679dcd639ab1b8d5accf8d68c541979dc7e7f51f9c7dcf8
registry.redhat.io/distributed-tracing/jaeger-es-index-cleaner-rhel7@sha256:09cb783968fc1dab66e8a2e788105b3b2ac0d1ef2ae9c8fc763b149ce8b332f2
registry.redhat.io/distributed-tracing/jaeger-es-rollover-rhel7@sha256:7c1400ebcd3de94cc937ae337924f95aad45de9739e721c4c61db1f62279636f

registry.redhat.io/openshift4/ose-oauth-proxy:latest
registry.redhat.io/openshift-service-mesh/kiali-rhel7-operator@sha256:1ab53b817097f63182115bea016e55cb3773a0fcc0ec73fe53549d29edc8c172
registry.redhat.io/openshift-service-mesh/kiali-rhel7@sha256:76667b3532df11a511b03c4efa165723cff48aa5fb2e56a2ceb693c02a6bce7a
registry.redhat.io/openshift-service-mesh/kiali-rhel7@sha256:e1fb3df10a7f7862e8549ad29e4dad97b22719896c10fe5109cbfb3b98f56900
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
)

for image in ${images[@]}; do
	src=$image
	dst=${DESTDIR}/${image##*/}.tar	
	podman pull $src
	podman save $src > $dst
done
