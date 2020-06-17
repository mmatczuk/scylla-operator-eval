create:
	eksctl create cluster -f eks-cluster.yaml
	eksctl create nodegroup -f eks-pools.yaml
	helm template -f provisioner-values.yaml local-volume ../provisioner > local-volume-provisioner.yaml
	kubectl apply -f local-volume-provisioner.yaml