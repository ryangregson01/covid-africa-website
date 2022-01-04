#!/bin/sh
# This script does not respond to SIGINT which causes containers to take
# significant time to die (i.e., the container-runtime will wait until
# forcefully killing the container).
python manage.py makemigrations --no-input || exit $?
python manage.py migrate --no-input || exit $?
# launch WSGI server
gunicorn --bind :8000 --workers 3 --threads 4 --reload covid_dashboard.wsgi
