FROM python:3.7-alpine

ENV PYTHONUNBUFFERED 1

# Add code and directories
RUN mkdir /ceiss_backend
WORKDIR /ceiss_backend
COPY ./django /ceiss_backend/django
COPY ./scripts /ceiss_backend/scripts
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

# nginx configuration
RUN mkdir -p /run/nginx
# Alpine image doesn't use the normal sites/available/sites-enabled approach
# of nginx configuration files, instead, it reads the configurations directly
# from the folder below
COPY nginx/ceiss_backend.conf /etc/nginx/conf.d/ceiss_backend.conf
# Bind nginx output to stdout and stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

# Remove all cache and temp files.
RUN rm -rf /tmp/* var/tmp/*

# USER user