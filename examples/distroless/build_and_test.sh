#!/bin/bash

source=$1
branch=$2

if [ -z "$source" ]; then
  source="https://github.com/rancher/local-path-provisioner.git"
fi

if [ -z "$branch" ]; then
  branch="master"
fi

docker build --build-arg GIT_REPO "$source" --buid-arg GIT_BRANCH "$branch" -t lpp-distroless-provider -f Dockerfile.provisioner .

docker build -t lpp-distroless-helper -f Dockerfile.helper .

kind create cluster --config=kind.yaml --name test-lpp-distroless

kind load docker-image --name test-lpp-distroless lpp-distroless-provider lpp-distroless-provider:v0.0.1

kind load docker-image --name test-lpp-distroless lpp-distroless-helper lpp-distroless-helper:v0.0.1

kubectl apply -k .