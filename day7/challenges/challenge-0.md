# Challenge 0: Setup your System

## Here is what you will learn 🎯

In this challenge you will learn:

- What prerequisites are needed for dealing with Kubernetes and Azure Kubernetes Service
- How to install them

## Table Of Contents

1. [Git Version Control](#git-version-control)
2. [Azure CLI](#azure-cli)
3. [Kubectl](#kubectl)
4. [Helm](#helm)
5. [Terraform](#terraform)

## Git Version Control

The repository is located at GitHub, so - obviously - we'll need a local _Git client_ to interact with the repository. Download and install the appropriate version of Git for you here: <https://git-scm.com/download>

## Azure CLI

We will be using the _Azure command line interface_ to create and interact with resources running in Azure.

To install it, go to <https://docs.microsoft.com/cli/azure/install-azure-cli?view=azure-cli-latest> and choose your platform.

When finished, login to your Azure account from the command line:

```shell
$ az login
You have logged in. Now let us find all the subscriptions to which you have access...
```

A browser window will open, login to Azure and go back to the command prompt. Your active subscription will be shown as JSON, e.g.:

```json
{
  "cloudName": "AzureCloud",
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "isDefault": false,
  "name": "Your Subscription Name",
  "state": "Enabled",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "user": {
    "name": "xxx@example.com",
    "type": "user"
  }
}
```

If you have multiple subscriptions, make sure your are working with the correct one!

```shell
$ az account show
{
  "cloudName": "AzureCloud",
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "isDefault": false,
  "name": "Your Subscription Name",
  "state": "Enabled",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "user": {
    "name": "xxx@example.com",
    "type": "user"
  }
}
```

If that is not the correct one, follow these steps below:

```shell
$ az account list -o table
[the list of available subscriptions is printed]

$ az account set -s <SUBSCRIPTIONID_YOU_WANT_TO_USE>
```

## Kubectl

`kubectl` is the _command line interface_ for Kubernetes. You will need the tool to interact with the cluster, e.g. to create a pod, a deployment or a service.

If you already have the Azure CLI on your machine, you can just install it using the following command:

```shell
az aks install-cli
```

or refer to the documentation for you specific platform.

[Install kubectl on Linux](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-with-curl-on-linux)

[Install kubectl on macOS](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-macos)

[Install kubectl on Windows](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-on-windows-using-chocolatey-or-scoop)

## Helm

`Helm` is the _package manager_ for Kubernetes. We will need it for installing several 3rd party components for our solution:

<https://helm.sh/docs/intro/install/>

## Terraform

`Terraform` is an _open-source "infrastructure as code" software tool_ created by HashiCorp. It is a tool for building, changing, and versioning infrastructure safely and efficiently. We will use terraform to create several PaaS services like Azure SQL Db, CosmosDB etc. in this workshop.

<https://www.terraform.io/downloads.html>

[🔼 Day 7](../README.md) | [Next challenge ▶](./challenge-1.md)
