default:
	@ cat ./Makefile

IMAGE_TAG=mithril-test

export DOCKER_BUILDKIT=0





CONTAINER_TAG=khueue-diary
HERE=$(shell pwd -P)

# Examples:
# make up cmd="bash"
# make up cmd="npm run infra-generate"
up:
	docker build --tag ${CONTAINER_TAG} --file ./node-python.docker ./
	@ echo "Don't forget to run npm install from outside!"
	docker run \
		--interactive \
		--tty \
		--rm \
		--mount "type=bind,source=${HERE},target=/workdir" \
		-p 8080:8080 \
		${CONTAINER_TAG} \
		${cmd}

aws-build-and-deploy:
	docker build --tag khueue-diary-aws --file aws-build.docker ./
	docker run \
		--rm \
		--env AWS_DEFAULT_REGION \
		--env AWS_CONTAINER_CREDENTIALS_RELATIVE_URI \
		khueue-diary-aws \
		npm run app-build-and-deploy





app-docker-build:
	docker build --tag $(IMAGE_TAG) ./

app-npm: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--mount "type=bind,source=$(PWD)/scripts,target=/workdir/scripts" \
		$(IMAGE_TAG) \
		--help

app-dev: app-docker-build
	docker run --interactive --tty --rm \
		-p 1234:1234 \
		-p 4321:4321 \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--mount "type=bind,source=$(PWD)/scripts,target=/workdir/scripts" \
		$(IMAGE_TAG) \
		run dev

app-deploy: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--mount "type=bind,source=$(PWD)/scripts,target=/workdir/scripts" \
		$(IMAGE_TAG) \
		run deploy

app-lint: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--mount "type=bind,source=$(PWD)/scripts,target=/workdir/scripts" \
		$(IMAGE_TAG) \
		run lint

app-pretty: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--mount "type=bind,source=$(PWD)/scripts,target=/workdir/scripts" \
		$(IMAGE_TAG) \
		run pretty

app-outdated-deps: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--mount "type=bind,source=$(PWD)/scripts,target=/workdir/scripts" \
		$(IMAGE_TAG) \
		run outdated-deps

app-build: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--mount "type=bind,source=$(PWD)/scripts,target=/workdir/scripts" \
		$(IMAGE_TAG) \
		run build

app-watch-compile: app-docker-build
	docker run --interactive --tty --rm \
		--mount "type=bind,source=$(PWD)/app,target=/workdir/app" \
		--mount "type=bind,source=$(PWD)/scripts,target=/workdir/scripts" \
		$(IMAGE_TAG) \
		run watch-compile
