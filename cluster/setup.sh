#!/usr/bin/env bash

create_cluster()
{
  if k3d cluster list | grep -q $1; then
    echo "cluster with name '$1' already exists."
  else
    k3d cluster create $1
    # TODO: check kinda that it has been created.
  fi
}

drop_cluster()
{
  if k3d cluster list | grep -q $1; then
    k3d cluster delete $1
  fi
}
