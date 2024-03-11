# Usage

`terraform init -backend-config=backend.hcl`

`terraform plan -var-file=dev-terraform.tfvars`

## TODO

- Test prod
- Control terraform from CI/CD
- Finish kubernetes cluster
- Terragrunt

# Cluster install

## On every node

### Install kubeadm

```
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo yum install -y iproute-tc

sudo systemctl enable --now kubelet

modprobe br_netfilter
sudo echo 1 > /proc/sys/net/ipv4/ip_forward
sudo echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
sudo sysctl -p
```

### Install containerd

curl -O -L https://github.com/containerd/containerd/releases/download/v1.6.9/containerd-1.6.9-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-1.6.9-linux-amd64.tar.gz

curl -L https://raw.githubusercontent.com/containerd/containerd/main/containerd.service > /etc/systemd/system/containerd.service
systemctl daemon-reload
systemctl enable --now containerd

curl -L -O https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc

curl -L -O https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz