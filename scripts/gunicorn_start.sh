#!/bin/sh

# File structure inspired by the following tutorial: http://michal.karzynski.pl/blog/2013/06/09/django-nginx-gunicorn-virtualenv-supervisor/

NAME='django_server'
DJANGODIR='/ceiss_backend/django'
SOCKFILE='/ceiss_backend/django/run/gunicorn.sock'
NUM_WORKERS=3
DJANGO_WSGI_MODULE=config.wsgi

cd $DJANGODIR

# Check if postgres is ready
echo "Waiting for postgres..."

    while ! nc -z $DJANGO_DB_HOST $DJANGO_DB_PORT; do
      sleep 0.1
    done

echo "PostgreSQL started"

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Set up Django looking for changes
./manage.py collectstatic --noinput
./manage.py migrate --noinput

# Start Gunicorn processes
echo Starting Gunicorn.
exec gunicorn $DJANGO_WSGI_MODULE:application \
    --name $NAME \
    --bind=unix:$SOCKFILE \
    --workers $NUM_WORKERS \
    --log-level=info \
    --reload
    --access-logfile - 
    --error-logfile -

