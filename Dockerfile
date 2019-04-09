FROM python:3.7-alpine

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
RUN apk update
RUN apk upgrade
RUN apk add bash

RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps \
  gcc  libc-dev linux-headers postgresql-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps


RUN mkdir /ceiss_backend
WORKDIR /ceiss_backend

COPY ./django /ceiss_backend/django
COPY ./scripts /ceiss_backend/scripts

# Collect static files
RUN ./django/manage.py collectstatic


RUN adduser -D user
USER user
