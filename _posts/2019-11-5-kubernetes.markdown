---
layout: default
banner: main
title:  "Getting Started With Kubernetes"
---

# Kubernetes

### kubeadm

install:

[Kubeadm Installation Docs](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

### Prep

You need to clean a node if you have used kubernetes on it before.

> sudo kubeadm reset

Make sure that the ~/.kube/config (kubectl file) is deleted

Make sure swap is disabled. 

###  Start the cluster

On the master 

[Kubeadm Cluster Creation Docs](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

to speed thing up you can pull the kubeadm images first
> kubeadm config images pull

> sudo kubeadm init --pod-network-cidr=10.244.0.0/16

It is a good idea to store a copy of the kubeadm join command it will give you so you can add more nodes.

Run the kubeadm join command on any nodes you want to add to your cluster.

Also grab the kubeconfig file as instructed.

### Configure Pod Network

Lets look at the status of our cluster

> kubectl get nodes

Now we need to set up a network driver so our cluster can communicate

> kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

You can see your cluster running with 

> kubectl get nodes
> kubectl cluster-info

