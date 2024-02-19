#!/bin/bash

set -e

while ! nc -z $POSTGRES_HOST $POSTGRES_PORT; do
  echo "Waiting for Postgres Database... $POSTGRES_HOST:$POSTGRES_PORT"
  sleep 0.1
done

echo "Postgres Database is up and running! $POSTGRES_HOST:$POSTGRES_PORT"

python manage.py collectstatic --noinput
python manage.py migrate
python manage.py runserver