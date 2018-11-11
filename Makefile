default:
	@ cat ./Makefile

IMAGE_TAG=mithril-test

export DOCKER_BUILDKIT=0

app-docker-build:
	docker build --tag $(IMAGE_TAG) ./

app-setup:
	rm -rf ./app/_build.dev/*
	rm -rf ./app/_build.dist/*
	mkdir -p ./app/_build.dev
	mkdir -p ./app/_build.dist

app-yarn: app-setup app-docker-build
	docker run --interactive --tty --rm \
		-p 1234:1234 \
		-p 4321:4321 \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		--help

app-dev: app-setup app-docker-build
	docker run --interactive --tty --rm \
		-p 1234:1234 \
		-p 4321:4321 \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		run dev

app-lint: app-setup app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		run lint

app-pretty: app-setup app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		run pretty

app-outdated-deps: app-setup app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		run outdated-deps

app-build: app-setup app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		run build

app-watch-compile: app-setup app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		$(IMAGE_TAG) \
		run watch-compile
