#!/usr/bin/env bash

set -x

systemctl start scylla-server.slice
cg_name=$(cat /proc/$(ps -C scylla -o pid=)/cgroup | grep kubepods | cut -d: -f 3 | head -n 1)
for kind in cpu cpuacct blkio; do
    for pid in $(cat /sys/fs/cgroup/${kind}${cg_name}/tasks); do
        echo ${pid} > /sys/fs/cgroup/${kind}/scylla.slice/tasks
    done
done
