#!/bin/sh

# File structure inspired by the following tutorial: http://michal.karzynski.pl/blog/2013/06/09/django-nginx-gunicorn-virtualenv-supervisor/

NAME='django_server'
DJANGODIR='/django'
SOCKFILE='/django/run/gunicorn.sock'
LOGFILE='/var/log/ceiss_backend/ceiss_backend.log' 
NUM_WORKERS=3
DJANGO_WSGI_MODULE=config.wsgi

cd $DJANGODIR

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Set up Django looking for changes
./manage.py collectstatic --noinput
./manage.py migrate

# Start Gunicorn processes
echo Starting Gunicorn.
exec gunicorn $DJANGO_WSGI_MODULE:application \
    --name $NAME \
    --bind=unix:$SOCKFILE \
    --workers $NUM_WORKERS \
    --log-level=debug \
    --log-file=$LOGFILE \
    # --daemon
    # --bind=unix:$SOCKFILE \

