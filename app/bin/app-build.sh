#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

OUT_DIR=./app/_build/dist

rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}"
parcel build ./app/src/index.pug \
	--out-dir "${OUT_DIR}" \
	--log-level 4
