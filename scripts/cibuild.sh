#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" && cd "${SCRIPT_DIR}" && source ./_helpers

function executeStep {
    local step=$1

    _log "Executing Step: $step"
    $step || {
        _log "FAILED: $1";
        ./cleanup.sh
        exit 1
    }
}

executeStep ./build.sh
executeStep ./cleanup.sh
