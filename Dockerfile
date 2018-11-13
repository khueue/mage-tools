FROM node:11.1.0-alpine

WORKDIR /workdir

# Parcel requires util-linux.
RUN apk add --no-cache \
	build-base \
	python \
	bash \
	util-linux

COPY ./package.json ./
RUN npm install --verbose

ENTRYPOINT ["npm"]
CMD ["--help"]
