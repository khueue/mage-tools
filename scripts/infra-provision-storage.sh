#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

export AWS_DEFAULT_REGION=eu-west-1

./scripts/infra-generate.sh

aws cloudformation deploy \
	--stack-name MageTools-Storage \
	--template-file ./cloudformation/generated/storage.py.template