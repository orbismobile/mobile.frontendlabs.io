#!/bin/sh

docker-compose -f ./docker-compose.overwrite.yml run --rm hugo
#docker-compose down --remove-orphans
docker-compose -f ./docker-compose.overwrite.yml up web
