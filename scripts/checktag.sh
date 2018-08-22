#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

TAG_VER=$1

PODSPEC="SPIClient-iOS.podspec"
VER_RE="s.version *= *'([0-9.]+)'"

if [[ `cat $PODSPEC` =~ $VER_RE ]] && [ ${BASH_REMATCH[1]} == "$TAG_VER" ]; then
    echo "Versions matched"
    exit 0
fi

echo "Versions mismatched"
exit 1
