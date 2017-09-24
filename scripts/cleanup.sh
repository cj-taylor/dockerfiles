#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" && source "${SCRIPT_DIR}/_helpers"

_log 'Removing spurious intermediate images'
docker rmi $(docker images -f dangling=true -q)
