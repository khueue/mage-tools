FROM node:8.12.0-alpine

WORKDIR /workdir

RUN apk add --no-cache \
	bash \
	util-linux \
	yarn

COPY ./package.json ./
RUN yarn install

ENTRYPOINT ["yarn", "--help"]
