#!/bin/bash

set -e

rm -rf ./tmp
mkdir ./tmp

git clone . ./tmp/_ytt_lib/github.com/k14s/k8s-lib
cp -r examples/ ./tmp

ytt tpl -R -f ./tmp --filter-template-file app.yml
ytt tpl -R -f ./tmp --filter-template-file app-with-volumes.yml
ytt tpl -R -f ./tmp --filter-template-file app-with-overlay.yml
