#!/bin/bash

set -eux

release_name="credhub-release-tarball"
build_number=$(ls credhub-release-tarball/*.tgz | sed -e "s/.*\.\([0-9]*\)\.tgz/\1/g")

echo ${release_name} > ${RELEASE_NAME_OUTPUT_PATH}/name
echo ${build_number} > ${RELEASE_NAME_OUTPUT_PATH}/tag