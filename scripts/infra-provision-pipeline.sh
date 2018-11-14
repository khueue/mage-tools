#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

export AWS_DEFAULT_REGION=eu-west-1

./scripts/infra-generate.sh

aws cloudformation deploy \
	--capabilities CAPABILITY_IAM \
	--stack-name MageTools-Pipeline \
	--template-file ./cloudformation/generated/pipeline.py.template
