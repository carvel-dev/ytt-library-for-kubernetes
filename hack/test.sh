#!/bin/bash

set -e

rm -rf ./tmp
mkdir ./tmp

git clone . ./tmp/_ytt_lib/github.com/k14s/k8s-lib
cp -r examples/ ./tmp

ytt tpl -R -f ./tmp --file-mark app.yml:exclusive-for-output=true
ytt tpl -R -f ./tmp --file-mark app-with-volumes.yml:exclusive-for-output=true
ytt tpl -R -f ./tmp --file-mark app-with-overlay.yml:exclusive-for-output=true
