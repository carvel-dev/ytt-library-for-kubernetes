#!/bin/bash

set -e

ytt tpl -R -f . --filter-template-file example.yml
ytt tpl -R -f . --filter-template-file example-with-volumes.yml
