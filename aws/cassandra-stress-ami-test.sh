#!/usr/bin/env bash

taskset -c 0-3 cassandra-stress write no-warmup cl=ONE duration=2m -schema 'replication(factor=1)' -port jmx=6868 -mode cql3 native -rate threads=100 -pop seq=1..30000000 -node ${1} > 1.log &

taskset -c 4-7 cassandra-stress write no-warmup cl=ONE duration=2m -schema 'replication(factor=1)' -port jmx=6868 -mode cql3 native -rate threads=100 -pop seq=1..30000000 -node ${1} > 2.log &

wait < <(jobs -p)

tail 1.log -n 20
tail 2.log -n 20
