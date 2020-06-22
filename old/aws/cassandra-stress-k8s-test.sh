#!/usr/bin/env bash

kubectl delete -f cassandra-stress-write.yaml
kubectl apply -f cassandra-stress-write.yaml
