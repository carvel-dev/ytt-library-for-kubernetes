#!/bin/bash

set -e -x

rm -rf ./tmp
mkdir ./tmp

git commit --allow-empty -am './hack/test.sh'
git clone . ./tmp/_ytt_lib/github.com/k14s/k8s-lib
git reset --soft head~1
cp -r examples/ ./tmp

ytt -f ./tmp --file-mark app.yml:exclusive-for-output=true
ytt -f ./tmp --file-mark app-with-volumes.yml:exclusive-for-output=true
ytt -f ./tmp --file-mark app-with-overlay.yml:exclusive-for-output=true
ytt -f ./tmp --file-mark nsa.yml:exclusive-for-output=true

echo "SUCCESS (but also STAGED ALL FILES IN GIT)"
