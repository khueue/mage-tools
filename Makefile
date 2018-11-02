default:
	@ cat ./Makefile

IMAGE_TAG=mithril-test

app-docker-build:
	docker build --quiet --tag $(IMAGE_TAG) ./

app-setup:
	rm -rf ./dist
	mkdir -p ./dist

app-dev: app-setup app-docker-build
	docker run \
		--interactive \
		--tty \
		--rm \
		-p 1234:1234 \
		-p 4321:4321 \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--mount "type=bind,source=$(PWD)/dist,target=/workdir/dist" \
		--name $(IMAGE_TAG)-app-dev \
		$(IMAGE_TAG) \
		run dev

app-build: app-setup app-docker-build
	docker run \
		--interactive \
		--tty \
		--rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--mount "type=bind,source=$(PWD)/dist,target=/workdir/dist" \
		--name $(IMAGE_TAG)-app-build \
		$(IMAGE_TAG) \
		run build

app-watch-compile: app-setup app-docker-build
	docker run \
		--interactive \
		--tty \
		--rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--name $(IMAGE_TAG)-app-watch-compile \
		$(IMAGE_TAG) \
		run watch-compile
