#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

export AWS_DEFAULT_REGION=us-east-1

./scripts/infra-generate.sh

aws cloudformation deploy \
	--stack-name MageTools-Global \
	--template-file ./cloudformation/generated/global.py.template
