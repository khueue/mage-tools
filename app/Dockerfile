FROM node:11.1.0-alpine

WORKDIR /workdir

RUN apk add --no-cache \
	bash

# For NPM (node-gyp).
RUN apk add --no-cache \
	build-base \
	python

# For Parcel.
RUN apk add --no-cache \
	util-linux

COPY ./package.json ./
RUN npm install && npm cache clean --force
