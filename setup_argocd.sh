#!/usr/bin/env bash

source .env

kubectl apply -n $NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

if kubectl get pods -n $NAMESPACE | grep -q $NAMESPACE; then
  echo "argo is installed and running."
fi

# expose argo cd api server
kubectl port-forward svc/argocd-server -n argocd 8080:443 > port-forward.log 2>&1 &

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
