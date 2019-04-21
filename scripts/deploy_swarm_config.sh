#!/bin/sh

# TODO: Refactor logic of this script

if [ ! -z "$1" ]
  then
    current="$(pwd)"
    cd "$(dirname "$(readlink -f "$0")")"

    echo "'$current'" '->' "'$(pwd)'" #show paths for demo purposes
    cd "$1"
    echo "'$1'" '->' "'$(pwd)'" #show new path for demo purposes

  else
  echo "ERROR: No argument supplied for env file directory"
  exit 1
fi

if [ ! -z "$2" ]
  then
    docker-compose config | docker stack deploy -c - $1
  else
    echo "ERROR: No argument supplied for name of stack"
    exit 1
fi

#!/bin/bash


