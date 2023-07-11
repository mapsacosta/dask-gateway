#!/bin/sh

docker build -t ssiregistry.fnal.gov/eaf/dask-gateway-server:2023.1.1 .
docker push ssiregistry.fnal.gov/eaf/dask-gateway-server:2023.1.1
