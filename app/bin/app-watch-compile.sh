#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

tsc \
	--project ./app/src/ts/tsconfig.json \
	--watch \
	--outDir ./watch-output
