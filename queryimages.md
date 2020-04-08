curl --cacert /home/opregistry/certs/domain.crt -X GET https://admin:redhat@work.jaysonzhao:5000/v2/_catalog |jq .[]|sed 's/,/ /g'
