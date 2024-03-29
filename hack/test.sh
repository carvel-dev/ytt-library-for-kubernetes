#!/bin/bash

set -e -x

rm -rf ./tmp
mkdir ./tmp

git commit --allow-empty -am './hack/test.sh'
git clone . ./tmp/_ytt_lib/github.com/vmware-tanzu/carvel-ytt-library-for-kubernetes
git reset --soft head~1

ytt -f ./tmp -f ./examples/app.yml
ytt -f ./tmp -f ./examples/app-with-volumes.yml
ytt -f ./tmp -f ./examples/app-with-overlay.yml
ytt -f ./tmp -f ./examples/nsa.yml

ytt -f ./kubeconfig -v address=foo.com -v username=admin -v password=bar
ytt -f ./kubeconfig -v address=foo.com -v username=admin -v password=bar --data-value-file ca_cert=<(cat ./hack/sample-cert.pem)

echo "SUCCESS (but also STAGED ALL FILES IN GIT)"
