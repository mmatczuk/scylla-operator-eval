#!/usr/bin/env bash

for i in $(seq 0 $1); do
    kubectl logs jobs.batch/cassandra-stress-${i} -n scylla | tail -n 20
done
