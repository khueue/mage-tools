#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

aws s3 sync \
	--delete \
	./app/_build/dist \
	s3://khueue-mage-tools-app/
