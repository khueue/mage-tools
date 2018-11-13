#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

parcel build ./app/src/index.pug \
	--out-dir ./app/_build/dist \
	--log-level 4
