#!/bin/bash

down()
{
  # shut down anything that's running rn
  docker-compose down;

  # delete any volumes named registry or registry_in
  docker volume rm -f registry;
  docker volume rm -f registry_in;
}

up()
{
  # bind variable
  REGISTRY_PARENT_DIR=$1

  # create volumes mapped to argument $PATH
  docker volume create --driver local -o o=bind -o type=none \
  -o device=$REGISTRY_PARENT_DIR/registry registry;
  docker volume create --driver local -o o=bind -o type=none \
  -o device=$REGISTRY_PARENT_DIR/registry_in registry_in;

  # run dockers
  docker-compose up -d;
}

build()
{
  # create dockerfiles
  docker-compose build;
}

clear()
{
  # bind variable
  REGISTRY_PARENT_DIR=$1

  # explicitly only clear /registry
  rm -r $REGISTRY_PARENT_DIR/registry/*
}

# $1 => up | down | build | clear | update
# $1 => registry and intake parent directory

if [ $1 == "down" ]
  then
    down;
fi

if [ $1 == "up" ]
  then
    up $2;
fi

if [ $1 == "build" ]
  then
    build;
fi

if [ $1 == "clear" ]
  then
    clear $2;
fi

# down + build + up
if [ $1 == "update" ]
  then
    down;
    build;
    up $2;
fi
