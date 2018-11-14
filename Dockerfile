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

RUN apk add --no-cache curl
RUN \
	curl https://bootstrap.pypa.io/get-pip.py --output ./get-pip.py && \
	python ./get-pip.py && \
	rm ./get-pip.py

COPY ./requirements.txt ./
RUN pip install -r ./requirements.txt

ENTRYPOINT ["npm"]
CMD ["--help"]
