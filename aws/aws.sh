#!/usr/bin/env bash

#
# Copyright (C) 2017 ScyllaDB
#

set -eu -o pipefail

eksctl create cluster -f eks-cluster.yaml
eksctl create nodegroup -f eks-pools.yaml

helm template -f provisioner-values.yaml local-volume ../provisioner > local-volume-provisioner.yaml

kubectl apply -f local-volume-provisioner.yaml
kubectl apply -f operator.yaml
kubectl apply -f cluster.yaml
