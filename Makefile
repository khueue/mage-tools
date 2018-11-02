default:
	@ cat Makefile

IMAGE_TAG=mithril-test

docker-build:
	docker build --quiet --tag $(IMAGE_TAG) ./

app-dev: docker-build
	rm -rf ./dist
	mkdir -p ./dist
	docker run \
		--interactive \
		--tty \
		--rm \
		-p 1234:1234 \
		-p 4321:4321 \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--mount "type=bind,source=$(PWD)/dist,target=/workdir/dist" \
		--entrypoint yarn \
		--name $(IMAGE_TAG)-app-dev \
		$(IMAGE_TAG) \
		run dev

app-build: docker-build
	rm -rf ./dist
	mkdir -p ./dist
	docker run \
		--interactive \
		--tty \
		--rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--mount "type=bind,source=$(PWD)/dist,target=/workdir/dist" \
		--entrypoint yarn \
		--name $(IMAGE_TAG)-app-build \
		$(IMAGE_TAG) \
		run build

app-watch-compile: docker-build
	rm -rf ./dist
	mkdir -p ./dist
	docker run \
		--interactive \
		--tty \
		--rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--entrypoint yarn \
		--name $(IMAGE_TAG)-app-watch-compile \
		$(IMAGE_TAG) \
		run watch-compile
