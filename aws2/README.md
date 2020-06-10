```
sudo docker run --rm --name some-scylla --network host \
-v /etc/scylla.d/:/etc/scylla.d/ \
--mount type=bind,source=/var/lib/scylla,target=/var/lib/scylla \
--entrypoint /scylla-service.sh -d scylladb/scylla:4.0.1
```