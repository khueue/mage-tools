FROM mhart/alpine-node:8.7
#FROM 3.7.1-alpine3.8

WORKDIR /workdir

RUN apk add --no-cache \
	bash \
	curl \
	python

RUN \
	curl https://bootstrap.pypa.io/get-pip.py --output ./get-pip.py && \
	python ./get-pip.py && \
	rm ./get-pip.py

COPY ./ ./

RUN pip install -r ./requirements.txt

RUN npm install
