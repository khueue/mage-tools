#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

DIST_FOLDER=./app/_build/dist
BUCKET=khueue-mage-tools-app

echo
echo "--- Upload all files except index.html ..."
aws s3 cp \
	--recursive \
	--exclude index.html \
	--cache-control max-age=2592000 \
	${DIST_FOLDER} \
	s3://${BUCKET}/

echo
echo "--- Request every file once, to fill the cache ..."
for file in ${DIST_FOLDER}/*; do
	basename=${file##*/}
	echo "/${basename}"
	curl \
		--verbose \
		--silent \
		--header "Accept-Encoding: gzip, deflate, br" \
		https://mage.khueue.com/${basename} \
		2>&1 \
	| grep x-cache
done

echo
echo "--- Upload index.html last, to switch smoothly to new version ..."
aws s3 cp \
	--cache-control max-age=10 \
	${DIST_FOLDER}/index.html \
	s3://${BUCKET}/

echo
echo "--- Remove files from previous deploys ..."
aws s3 sync \
	--delete \
	${DIST_FOLDER} \
	s3://${BUCKET}/
