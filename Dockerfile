FROM python:3.7-alpine

ENV PYTHONUNBUFFERED 1

# Add code and directories
RUN mkdir /ceiss_backend
WORKDIR /ceiss_backend
COPY ./django /ceiss_backend/django
# COPY ./scripts /ceiss_backend/scripts
RUN mkdir /var/log/ceiss_backend/
RUN touch /var/log/ceiss_backend/ceiss_backend.log

RUN adduser -D user
RUN chown user /var/log/ceiss_backend/ceiss_backend.log

# Dependencies and scripts setup
COPY ./requirements.txt /requirements.txt
RUN apk update
RUN apk upgrade
RUN apk add --no-cache bash nginx
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps \
  gcc  libc-dev linux-headers postgresql-dev 
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

# Collect static files
RUN ./django/manage.py collectstatic

# nginx configuration
RUN mkdir -p /run/nginx
RUN mkdir /etc/nginx/sites-available/
RUN mkdir /etc/nginx/sites-enabled/
COPY nginx/ceiss_backend.conf /etc/nginx/sites-available/ceiss_backend.conf
# RUN rm /etc/nginx/sites-enabled/*
RUN ln -s /etc/nginx/sites-available/ceiss_backend.conf /etc/nginx/sites-enabled/ceiss_backend.conf

# Remove all cache and temp files.
RUN rm -rf /tmp/* var/tmp/*

COPY ./scripts /ceiss_backend/scripts
# USER user