#!/bin/bash

set -e -x

rm -rf ./tmp
mkdir ./tmp

git commit --allow-empty -am './hack/test.sh'
git clone . ./tmp/_ytt_lib/github.com/k14s/k8s-lib
git reset --soft head~1

ytt -f ./tmp -f ./examples/app.yml
ytt -f ./tmp -f ./examples/app-with-volumes.yml
ytt -f ./tmp -f ./examples/app-with-overlay.yml
ytt -f ./tmp -f ./examples/nsa.yml

echo "SUCCESS (but also STAGED ALL FILES IN GIT)"
