default:
	@ cat ./Makefile

# Convenience wrappers.
#
# make server
# make npm-install
# make build-and-deploy

server:
	make app-cmd-with-ports cmd=./bin/server

npm-install:
	make app-cmd cmd="npm install && npm outdated"

build-and-deploy:
	limes assume private
	make app-cmd cmd=./bin/build
	make infra-cmd cmd=./bin/deploy-app

# Application tooling.
#
# make app-cmd cmd=./bin/build
# make app-cmd cmd=./bin/pretty
# make app-cmd-with-ports cmd=./bin/server
# make app-cmd cmd="npm outdated"

IMAGE_TAG_APP=mage-tools-app

app-cmd: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir" \
		${IMAGE_TAG_APP} \
		bash -c "${cmd}"

app-cmd-with-ports: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir" \
		--publish 1234:1234 \
		--publish 4321:4321 \
		${IMAGE_TAG_APP} \
		bash -c "${cmd}"

app-docker-build:
	docker build \
		--tag ${IMAGE_TAG_APP} \
		./app

app-clean-all:
	rm -rf ./app/_build/dev
	rm -rf ./app/_build/dist
	rm -rf ./app/.cache
	rm -rf ./app/node_modules
	rm -rf ./app/package-lock.json

# Infrastructure tooling.
#
# make infra-cmd cmd=./bin/generate
# make infra-cmd cmd=./bin/deploy-app
# make infra-cmd cmd="pip freeze"

IMAGE_TAG_INFRA=mage-tools-infra

infra-cmd: infra-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/infrastructure,target=/workdir" \
		--mount "type=bind,source=$(PWD)/app/_build,target=/app/_build",readonly \
		${IMAGE_TAG_INFRA} \
		bash -c "${cmd}"

infra-docker-build:
	docker build \
		--tag ${IMAGE_TAG_INFRA} \
		./infrastructure
