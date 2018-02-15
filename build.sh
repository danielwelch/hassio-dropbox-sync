#!/bin/bash
set -ev
if [ -z ${TRAVIS_TAG} ]; then
    echo "Untagged build found."
else
    echo "New git tagged build found."
fi
docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
docker run -it --rm --privileged --name ${ADDON_NAME} \
        -v ~/.docker:/root/.docker \
        -v "$(pwd)":/docker \
        hassioaddons/build-env:latest \
        --target ${ADDON_NAME} \
        --git \
        --all \
        --from "homeassistant/{arch}-base"
        --author "Daniel Welch <dwelch2102@gmail.com>"
        --doc-url "${GITHUB_URL}"
echo "Local Docker build successful."
