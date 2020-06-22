.PHONY: create
create:
	eksctl create cluster -f eks-cluster.yaml
	eksctl create nodegroup -f eks-pools.yaml
	kubectl apply -f local-volume-provisioner.yaml
	kubectl apply -f operator.yaml
	kubectl apply -f cluster.yaml

.PHONY: check
check:
	kubectl get pods -n scylla

.PHONY: monitoring
monitoring:
	kubectl create namespace monitoring
	helm upgrade --install scylla-prom --namespace monitoring stable/prometheus -f monitoring/prometheus-values.yaml
	helm upgrade --install scylla-graf --namespace monitoring stable/grafana -f monitoring/grafana-values.yaml

.PHONY: stress
stress:
	kubectl delete -f cassandra-stress-write.yaml ||:
	kubectl apply -f cassandra-stress-write.yaml

.PHONY: delete
delete:
	eksctl delete cluster -f eks-cluster.yaml
