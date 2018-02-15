#!/bin/bash
set -ev
if [ -z ${TRAVIS_TAG} ]; then
    echo "Untagged build. Exiting..."
    exit 0
else
    echo "New git tagged build found. Attempting to build..."
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
    echo "Build successful"
fi
