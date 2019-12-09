# Disconnected Install Red Hat Service Mesh (Istio)

## Disable the default OperatorSources.

```
$ oc patch OperatorHub cluster --type json \
    -p '[{"op": "add", "path": "/spec/disableAllDefaultSources", "value": true}]'
```

## Pull Operator content.

```
./get-operator.sh redhat-operators elasticsearch-operator
./get-operator.sh redhat-operators kiali-ossm
./get-operator.sh redhat-operators jaeger-product

```

## Create an Operator catalog image

```
mkdir manifets
./build-operator-catalog.sh 

```

## Push the Operator catalog image to a registry. 

```
oc create -f internal-operatorhub-catalog.yaml
oc get pods -n openshift-marketplace
oc get catalogsource -n openshift-marketplace
oc get packagemanifest -n openshift-marketplace

```


