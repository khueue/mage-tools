default:
	@ cat ./Makefile

# Convenience wrappers.
#
# make server
# make build-and-deploy

server:
	make app-cmd-with-ports cmd=./app/bin/server

build-and-deploy:
	limes assume private
	make app-cmd cmd=./app/bin/build
	make infra-cmd cmd=./infrastructure/bin/deploy-app

# Application tooling.
#
# make app-cmd cmd=./app/bin/server
# make app-cmd cmd=./app/bin/build
# make app-cmd cmd=./app/bin/pretty
# make app-cmd cmd="npm outdated"

IMAGE_TAG_APP=mage-tools-app

app-cmd: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		${IMAGE_TAG_APP} \
		${cmd}

app-cmd-with-ports: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--publish 1234:1234 \
		--publish 4321:4321 \
		${IMAGE_TAG_APP} \
		${cmd}

app-docker-build:
	docker build \
		--tag ${IMAGE_TAG_APP} \
		./app

# Infrastructure tooling.
#
# make infra-cmd cmd=./infrastructure/bin/generate
# make infra-cmd cmd=./infrastructure/bin/deploy-app
# make infra-cmd cmd="pip freeze"

IMAGE_TAG_INFRA=mage-tools-infra

infra-cmd: infra-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/infrastructure,target=/workdir/infrastructure" \
		--mount "type=bind,source=$(PWD)/app/_build,target=/workdir/app/_build",readonly \
		${IMAGE_TAG_INFRA} \
		${cmd}

infra-docker-build:
	docker build \
		--tag ${IMAGE_TAG_INFRA} \
		./infrastructure
