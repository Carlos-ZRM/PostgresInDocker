#!/bin/bash

docker build -t postgres-spacewalk .\
             #--build-arg http_proxy=http://10.0.202.7:8080 \
             #--build-arg https_proxy=https://10.0.202.7:8080 \
exit $?
