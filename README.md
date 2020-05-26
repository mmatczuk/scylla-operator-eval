# Scylla Operator Eval

## EKS

step 1: [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

step 2: Install eksctl

```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C ~/bin/
```

step 3: Go to `aws` dir

step 4: Run cluster with `aws.sh`

step 5: [Setup monitoring](https://github.com/scylladb/scylla-operator/blob/master/docs/generic.md#setting-up-monitoring)

step 6: Run c-s write test with `cassandra-stress-k8s-test.sh`

step 7: (Optional) get c-s client summary with `cassandra-stress-k8s-collect-n.sh 7`
