#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" && cd "${SCRIPT_DIR}" && source ./_helpers

JOBS=${JOBS:-2}
REPO="${REPO:-cjtaylor}"
ERRORS="$(pwd)/errors"

publish(){
  _log "Publishing: $1:$2"
	docker push ${REPO}/${1}:${2} || {
    _log "ERROR: PUBLISH - ${base}:${tag}" >> $ERRORS
    return 1;
  }
}

build(){
  _log "Build: $1"
	image=${1%Dockerfile}
	base=${image%%\/*}
	build_dir=$(dirname $1)
  tag='latest'

  docker build --rm --force-rm -t ${REPO}/${base}:${tag} "../$build_dir" || {
    _log "ERROR: BUILD - ${base}:${tag}" >> $ERRORS
    return 1;
  }
  publish "${base}" "${tag}"
}

buildAll(){
  dockerfiles=( $(find .. -iname 'Dockerfile' | sed 's|../||' | sort) )

  _log "Running in parallel with ${JOBS} jobs."
  parallel --tag --verbose --ungroup -j"${JOBS}" $SCRIPT_DIR/build.sh build "{1}" ::: "${dockerfiles[@]}"

  if [[ ! -f $ERRORS ]]; then
		_log "SUCCESS: All is whale!"
	else
		_log "FAIL: These images failed: $(cat $ERRORS)" >&2
		exit 1
	fi
}

run(){
	args=( "$@" )
	f=$1

	if [[ "$f" == "" ]]; then
		buildAll
	else
		"${args[@]}"
	fi
}

run "$@"
