FROM python:3.7.1-alpine3.8

WORKDIR /workdir

RUN apk add --no-cache \
	bash \
	curl

RUN pip install --no-cache-dir --upgrade pip

# Copy and install dependencies first.
COPY ./requirements.txt ./
RUN pip install --no-cache-dir --requirement ./requirements.txt

ENV PYTHONDONTWRITEBYTECODE=1
