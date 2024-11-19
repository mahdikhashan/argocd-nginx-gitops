#!/usr/bin/env bash

source ../.env

function create_cluster()
{
  if k3d cluster list | grep -q $1; then
    echo "cluster with name '$1' already exists."
  else
    k3d cluster create $1
    # TODO: check kinda that it has been created.
  fi
}

function drop_cluster()
{
  # TODO
  echo "drop"
}

create_cluster $CLUSTER_NAME

if kubectl config use-context "k3d-$CLUSTER_NAME" &>/dev/null && kubectl config current-context | grep -q "k3d-$CLUSTER_NAME"; then
  echo "switched to cluster '$CLUSTER_NAME'."
fi
