create:
	eksctl create cluster -f eks-cluster.yaml
	eksctl create nodegroup -f eks-pools.yaml
	kubectl apply -f local-volume-provisioner.yaml
