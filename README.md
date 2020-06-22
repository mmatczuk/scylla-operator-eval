# Scylla Operator Eval

This works aims at analysing Scylla's performance while running in Kubernetes.
More precisely it tries to run write throughput test against cluster running in [EKS](https://aws.amazon.com/eks/).
The test consists of 3 Scylla nodes running on i3.2xlarge machines (see scylla-pool) and 8 c-s workers running on 4 c4.2xlarge machines (see cassandra-stress-pool). 

This repository holds:
- EKS setup scripts that provision nodes in EKS
- Kubernetes files for setting up Scylla nodes, Monitoring and running c-s workers
- Modified Scylla docker container sources (mmatczuk/scylla)
- Benchmark results (see results directory) 

This repository does not hold [required Scylla-Operator modifications](https://github.com/scylladb/scylla-operator/commits/mmt/hack2).

Note that this work is a glued together hack, **running on different machines may require changes**. 

## Running it

Install Packages:

- [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Install eksctl](https://github.com/weaveworks/eksctl#installation)
- [Install helm3](https://helm.sh/docs/intro/install/)

Make sure to add auto completion to kubectl, it's recommended for all the above commands.

Add stable helm repo:

```
helm repo add stable https://kubernetes-charts.storage.googleapis.com
```

Go to `eks` directory

Run `make create` to provision resources and deploy Scylla nodes

Run `make check` to see if scylla nodes are ready, it may take a while but in the end you should see sth like:

```
kubectl get pods -n scylla
NAME                                          READY   STATUS    RESTARTS   AGE
scylla-cluster-eu-central-1-eu-central-1a-0   2/2     Running   0          14m
scylla-cluster-eu-central-1-eu-central-1a-1   2/2     Running   0          11m
scylla-cluster-eu-central-1-eu-central-1a-2   2/2     Running   0          8m9s
```

Run `make monitoring` to deploy Scylla Monitoring

Run `kubectl port-forward -n monitoring scylla-graf-XXXX 3000` the XXXX part should be autocompleted using tab. One can also get to know the pod name using `kubectl get pods -n monitoring`.

Open browser at http://localhost:3000/, default credentials are admin:admin

Run `make stress` to start c-s workers

When test is done use `./cassandra-stress-k8s-collect-n.sh 7` to collect c-s summary.

## Optimisations/Issues

- Use of Host networking
- Setting SQ net mode
- Correct CPU pinning
- Calling prepare script 
- Extra escaping k8s cgroup

The script `eks/kubesc/kubesc.sh` when run on nodes running scylla-server (scylla stateful set) would move its processes from kubernetes to scylla-server slice.
This gives additional boost of approx 5k op/s.
Note it needs to be run with sudo or as a root.
 
## Cookbook

- Open bash in Scylla container `kubectl exec -n scylla -it scylla-cluster-eu-central-1-eu-central-1a-0 -- bash`
- SSH to node, `kubectl get nodes -o yaml | less` find node of interest and its `ExternalIP`, `ssh ec2-user@<ExternalIP>`
- Follow c-s logs of a task `kubectl logs -n scylla -f cassandra-stress-XXXX`
