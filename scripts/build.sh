#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" && cd "${SCRIPT_DIR}" && source ./_helpers

build(){
    cd ..
    dockerfiles=( $(find . -iname 'Dockerfile' | sed 's|./||' | sort) )

    for dockerfile in  "${dockerfiles[@]}"; do
        _log "Building $dockerfile"
        local base=${dockerfile%%\/*}
        local context=${dockerfile%Dockerfile}
        docker build --rm --force-rm -t "$base":latest "$context"
    done 
}

build