# Challenge 0 - Setup your System

## Install Kubectl

`kubectl` is the commandline interface for Kubernetes. You will need the tool to interact with the cluster, e.g. to create a pod, deployment or service.

If you already have the Azure CLI on your machine, you can just install it using the following command:

```zsh
$ az aks install-cli
```

Or refer to the documentation for you specific platform.

[Install kubectl on Linux](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-with-curl-on-linux)

[Install kubectl on macOS](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-macos)

[Install kubectl on Windows](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-on-windows-using-chocolatey-or-scoop)

## Install Helm

`Helm` is the package manager for Kubernetes. We will need it for installing several 3rd party components for our solution:

https://helm.sh/docs/intro/install/

## Terraform

`Terraform` is an open-source "infrastructure as code" software tool created by HashiCorp. It is a tool for building, changing, and versioning infrastructure safely and efficiently. We will use terraform to create several PaaS services like Azure SQL Db, ComsosDB etc. in this workshop.

https://www.terraform.io/downloads.html
