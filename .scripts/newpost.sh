#! /bin/sh

docker-compose exec --user $(id -u) hugo /bin/sh -c "hugo new posts/$1.md"
