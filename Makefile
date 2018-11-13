default:
	@ cat ./Makefile

IMAGE_TAG=mithril-test

export DOCKER_BUILDKIT=0

app-docker-build:
	docker build --tag $(IMAGE_TAG) ./

app-npm: app-docker-build
	docker run --interactive --tty --rm \
		-p 1234:1234 \
		-p 4321:4321 \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		--help

app-dev: app-docker-build
	docker run --interactive --tty --rm \
		-p 1234:1234 \
		-p 4321:4321 \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		run dev

app-lint: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		run lint

app-pretty: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		run pretty

app-outdated-deps: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		run outdated-deps

app-build: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		run build

app-watch-compile: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		run watch-compile
