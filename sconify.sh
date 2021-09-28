#!/bin/bash

VERSION=6.0.1

# declare an image name
IMG_NAME=iexec-cloud-python-crypto-analysis
IMG_FROM=${IMG_NAME}:latest
IMG_TO=${IMG_NAME}:tee-debug-${VERSION}

# build the regular non-TEE image
# docker build ../standard/Dockerfile -t ${IMG_FROM}

# pull the SCONE curated image corresponding to our base image
docker pull registry.scontain.com:5050/sconecuratedimages/apps:python-3.7.3-alpine3.10

# declare the app entrypoint
ENTRYPOINT="python3 /app/app.py"

# run the sconifier to build the TEE image based on the non-TEE image
docker run -it --rm \
            -v /var/run/docker.sock:/var/run/docker.sock \
            registry.scontain.com:5050/scone-production/iexec-sconify-image:5.3.7 \
            sconify_iexec \
            --name=${IMG_NAME} \
            --from=${IMG_FROM} \
            --to=${IMG_TO} \
            --binary-fs \
            --fs-dir=/app \
            --host-path=/etc/hosts \
            --host-path=/etc/resolv.conf \
            --binary=/usr/local/bin/python3.7 \
            --heap=1G \
            --dlopen=2 \
            --verbose \
            --command=${ENTRYPOINT} \
            && echo -e "\n------------------\n" \
            && echo "successfully built TEE docker image => ${IMG_TO}" \
            && echo "application mrenclave.fingerprint is $(docker run -it --rm -e SCONE_HASH=1 ${IMG_TO})"