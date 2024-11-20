#!/usr/bin/env bash

if which k3d >/dev/null; then
  k3d version
else
  echo "plz first install k3d!!!"
fi
