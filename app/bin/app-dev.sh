#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

parcel serve ./app/src/index.pug \
	--out-dir ./app/_build.dev \
	--port 1234 \
	--hmr-port 4321 \
	--log-level 4
