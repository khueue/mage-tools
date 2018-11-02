FROM node:8.12.0-alpine

WORKDIR /workdir

# Parcel requires util-linux.
RUN apk add --no-cache \
	bash \
	util-linux \
	yarn

COPY ./package.json ./
RUN yarn install

ENTRYPOINT ["yarn"]
CMD ["--help"]
