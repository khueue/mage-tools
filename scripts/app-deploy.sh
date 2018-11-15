#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

DIST_FOLDER=./app/_build/dist
BUCKET=khueue-mage-tools-app

# Upload everything (except index.html) with long TTL.
aws s3 cp \
	--recursive \
	--exclude index.html \
	--cache-control max-age=3600 \
	${DIST_FOLDER} \
	s3://${BUCKET}/

# Upload index.html last, to make a smooth transition to the new version.
aws s3 cp \
	--cache-control max-age=10 \
	${DIST_FOLDER}/index.html \
	s3://${BUCKET}/

# Remove files from previous deploys.
aws s3 sync \
	--delete \
	${DIST_FOLDER} \
	s3://${BUCKET}/
