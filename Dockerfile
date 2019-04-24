FROM python:3.7-alpine

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

# Dependencies and scripts setup
RUN apk add --update --no-cache postgresql-client nginx
RUN apk add --update --no-cache --virtual .tmp-build-deps \
  gcc  libc-dev linux-headers postgresql-dev python3-dev

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

RUN apk del .tmp-build-deps

# Add code and directories
RUN mkdir /ceiss_backend
WORKDIR /ceiss_backend
COPY ./django /ceiss_backend/django
COPY ./scripts /ceiss_backend/scripts

RUN adduser -D user

RUN chown -R user /ceiss_backend

USER user