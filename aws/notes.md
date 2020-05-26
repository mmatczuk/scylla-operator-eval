https://eksctl.io/introduction/

```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C ~/bin/
```

https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
pip2.7 install --user python-dateutil
```

https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html

```
curl -o ~/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator
chmod +x ~/bin/aws-iam-authenticator 
```

```
aws ec2 describe-regions
aws ec2 describe-availability-zones
```

https://eksctl.io/usage/schema/
```go
type NodeGroup struct {
	Name string `json:"name" jsonschema:"required"`
	// +optional
	AMI string `json:"ami,omitempty"`
	// +optional
	AMIFamily string `json:"amiFamily,omitempty"`
	// +optional
	InstanceType string `json:"instanceType,omitempty"`
	//+optional
	InstancesDistribution *NodeGroupInstancesDistribution `json:"instancesDistribution,omitempty"`
	// +optional
	InstancePrefix string `json:"instancePrefix,omitempty"`
	// +optional
	InstanceName string `json:"instanceName,omitempty"`
	// +optional
	AvailabilityZones []string `json:"availabilityZones,omitempty"`
	// +optional
	Tags map[string]string `json:"tags,omitempty"`
	// +optional
	PrivateNetworking bool `json:"privateNetworking"`

	// +optional
	SecurityGroups *NodeGroupSGs `json:"securityGroups,omitempty"`

	// +optional
	DesiredCapacity *int `json:"desiredCapacity,omitempty"`
	// +optional
	MinSize *int `json:"minSize,omitempty"`
	// +optional
	MaxSize *int `json:"maxSize,omitempty"`
	// +optional
	ASGMetricsCollection []MetricsCollection `json:"asgMetricsCollection,omitempty"`

	// +optional
	EBSOptimized *bool `json:"ebsOptimized,omitempty"`

	// +optional
	VolumeSize *int `json:"volumeSize,omitempty"`
	// +optional
	VolumeType *string `json:"volumeType,omitempty"`
	// +optional
	VolumeName *string `json:"volumeName,omitempty"`
	// +optional
	VolumeEncrypted *bool `json:"volumeEncrypted,omitempty"`
	// +optional
	VolumeKmsKeyID *string `json:"volumeKmsKeyID,omitempty"`
	// +optional
	VolumeIOPS *int `json:"volumeIOPS,omitempty"`

	// +optional
	MaxPodsPerNode int `json:"maxPodsPerNode,omitempty"`

	// +optional
	Labels map[string]string `json:"labels,omitempty"`

	// +optional
	Taints map[string]string `json:"taints,omitempty"`

	// +optional
	ClassicLoadBalancerNames []string `json:"classicLoadBalancerNames,omitempty"`

	// +optional
	TargetGroupARNs []string `json:"targetGroupARNs,omitempty"`

	// +optional
	SSH *NodeGroupSSH `json:"ssh,omitempty"`

	// +optional
	IAM *NodeGroupIAM `json:"iam,omitempty"`

	// +optional
	Bottlerocket *NodeGroupBottlerocket `json:"bottlerocket,omitempty"`

	// +optional
	PreBootstrapCommands []string `json:"preBootstrapCommands,omitempty"`

	// +optional
	OverrideBootstrapCommand *string `json:"overrideBootstrapCommand,omitempty"`

	// +optional
	ClusterDNS string `json:"clusterDNS,omitempty"`

	// +optional
	KubeletExtraConfig *InlineDocument `json:"kubeletExtraConfig,omitempty"`
}
```

https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html
https://kubernetes.io/docs/concepts/storage/storage-classes/#aws-ebs
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html

https://medium.com/@ivan.katliarchuk/k8s-dynamic-provisioning-of-persistent-volumes-on-aws-449902f9c69e

```
git clone git@github.com:weaveworks/eksctl.git
eksctl create cluster -f cluster.yaml --kubeconfig .kube_config
```

```
ScyllaDB 4.0.0 - ami-089a24addd969663e
ScyllaDB 4.0.0
```


https://github.com/scylladb/scylla-machine-image/blob/master/aws/ami/files/scylla_install_ami#L88


            scylla_raid_setup --disks /dev/nvme0n1


```
root@a29004184858:/# cat cpu_manager.sh 
#!/bin/bash

HOSTFS="/mnt/hostfs"

function sleep_forever() {
    while true; do sleep 100; done
}

function setup_kubectl() {
# Setup kubectl
    cd $HOSTFS/var/run/secrets/kubernetes.io/serviceaccount
    TOKEN=$(cat token)
    kubectl config set-cluster scylla --server=https://kubernetes.default --certificate-authority=ca.crt
    kubectl config set-credentials yanniszarkadas@gmail.com --token=$TOKEN
    kubectl config set-context scylla --cluster=scylla --user=yanniszarkadas@gmail.com
    kubectl config use-context scylla
}

setup_kubectl
echo "Changing kubelet configs and restarting the kubelet service"
if [[ `grep "cpuManagerPolicy" $HOSTFS/home/kubernetes/kubelet-config.yaml | wc -l` -eq 0 ]]
then
  kubectl drain $NODE --force --ignore-daemonsets --delete-local-data --grace-period=60
  echo cpuManagerPolicy: static | tee -a $HOSTFS/home/kubernetes/kubelet-config.yaml
elif [[ `grep "cpuManagerPolicy" $HOSTFS/home/kubernetes/kubelet-config.yaml | wc -l` -gt 1 ]]
then
  kubectl drain $NODE --force --ignore-daemonsets --delete-local-data --grace-period=60
  sed -i '/cpuManagerPolicy/d' $HOSTFS/home/kubernetes/kubelet-config.yaml
  echo cpuManagerPolicy: static | tee -a $HOSTFS/home/kubernetes/kubelet-config.yaml
else
  echo "Policy already there!"
  echo "Uncondoning the node"
  kubectl uncordon $NODE
  sleep_forever
fi
rm $HOSTFS/var/lib/kubelet/cpu_manager_state

# Couldn't get systemctl to work...
# Not a good solution, but it works
kill -9 $(pidof kubelet)

# systemctl restart kubelet
# echo "Here is the result"
# sudo journalctl -u kubelet | grep cpumanager
# echo "Uncondoning the node"
# kubectl uncordon $NODE
```

https://kubernetes.io/docs/tasks/administer-cluster/cpu-management-policies/

https://github.com/pingcap/tidb-operator/blob/master/manifests/local-dind/local-volume-provisioner.yaml