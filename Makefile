default:
	@ cat ./Makefile

# Convenience wrappers.

dev:
	make dev-cmd cmd="./app/bin/dev"

build-and-deploy:
	limes assume private
	make dev-cmd cmd="./app/bin/build"
	make infra-cmd cmd="./bin/deploy-app"

# Dev tooling.
#
# make dev-cmd cmd="./app/bin/build"
# make dev-cmd cmd="./app/bin/pretty"
# make dev-cmd cmd="npm outdated"

IMAGE_TAG_DEV=mage-tools-dev

dev-cmd: dev-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--publish 1234:1234 \
		--publish 4321:4321 \
		${IMAGE_TAG_DEV} \
		${cmd}

dev-docker-build:
	docker build \
		--tag ${IMAGE_TAG_DEV} \
		./app

# Infra tooling.
#
# make infra-cmd cmd="./bin/generate"
# make infra-cmd cmd="./bin/deploy-app"
# make infra-cmd cmd="pip freeze"

IMAGE_TAG_INFRA=mage-tools-infra

infra-cmd: infra-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/infrastructure,target=/workdir" \
		--mount "type=bind,source=$(PWD)/app/_build,target=/app/_build" \
		${IMAGE_TAG_INFRA} \
		${cmd}

infra-docker-build:
	docker build \
		--tag ${IMAGE_TAG_INFRA} \
		./infrastructure
