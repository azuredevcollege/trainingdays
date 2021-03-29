# Challenge 0 - Setup your System

## git Version Control

The repository is located at GitHub, so - obviously - we'll need a local git client to interact with the repo. Download and install the appropriate version of git for you here: <https://git-scm.com/download>

## Azure CLI

We will be using the Azure command line interface to create and interact with resources running in Azure. To install it, go to <https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest> and choose your platform.

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

## Install Kubectl

`kubectl` is the commandline interface for Kubernetes. You will need the tool to interact with the cluster, e.g. to create a pod, deployment or service.

If you already have the Azure CLI on your machine, you can just install it using the following command:

```shell
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
