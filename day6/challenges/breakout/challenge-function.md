# Create an Azure Function on Linux using a custom container

## Here is what you will learn

- Create an Azure Function that uses a BlobTrigger
- Build a custom image using Docker
- Run the container on your local development machine
- Run the container in Azure Container Instances

In this challenge you will learn how to use the Azure function runtime in a custom docker image. To get familiar with running the Azure function runtime in a custom docker image a sample Azure function is already created for you. The sample function listens for files in a StorageAccount (Blob). Each time a file is uploaded to a predefined container, the sample fumction is triggered and it receives the uploaded Blob. The blob is resized and stored to another location.
The sample Azure Function can be found [here in day6/apps/dotnetcore/BlobTriggerFunction](../apps/dotnetcore/BlobTriggerFunction).

## Run the Azure function on your local machine with docker

### Create an Azure Storage account

Open a shell and log in to your Azure subscription using Azure CLI.

```shell
az login
```

After you have logged in create a resource group where you want to add an Azure Storage Account

```shell
az group create -n <resource group name> -l <Azure region>
```

Now you can create the storage account and add two private containers. One container is used to store the raw images named 'originals' and the other container is used to store the processed images named 'processed'.

```shell
az storage account create --name <account name> --location eastus2 --resource-group <resource group name> --kind StorageV2 --access-tier Hot --sku Standard_LRS
az storage container create --name originals --account-name <storage account name>
az storage container create --name processed --account-name <storage account name>
```

Query the connection string and note it down.

```shell
az storage account show-connection-string --name <storage account name> --resource-group <resource group name>
```

### Build the custom image using Docker

To build the docker image open a shell and navigate to the application folder 'day6/apps/dotnetcore/BlobTriggerFunction' and run the following docker command to build the image.

```shell
docker build -t blobtriggerfunction:0.1 .
```

### Run the image

```shell
docker run -it -e StorageAccountConnectionString='<your storage connectionstring>' -e AzureWebJobsStorage='<your storage connectionstring>' blobtriggerfunction:0.1
```

### See it in action

Open the 'Azure Storage Explorer' and navigate to your Storage Account. Expand the Storage Account and you should see three containers under 'Blob Containers'. The '$logs' container is for diagnostic logs of the Storage Account. Go the the 'originals' container and upload an image. After the image was uploaded you should see a new output in your shell window where you started the docker container. Now navigate to the 'processed' container and you should see a new blob withe the prefix 'proc\_'.

### Housekeeping

Quit the running container by pressing Ctrl+C.
List all containers on your local machine

```shell
docker ps -a
```

Delete the blobtriggerfunction:0.1 container by specifying the container id.

```
docker rm <container id>
```

## Deploy the docker image to Azure Container Instances ACI

Azure Container Instances offers the fastest and simplest way to run a container on Azure, without having to manage any virtual machines. Azure Container Instances is a great solution for any scenario that can operate in isolated containers, including simple applications, task automation and build jobs. Take a look at the documentation [here](https://docs.microsoft.com/azure/container-instances/container-instances-overview) to get more information about Azure Container Instances.

### Create an Azure container registry

If you already have created an Azure container registry you can skip this step.

Before you can create a Azure container registry, you need a resource group to deploy it to.

```shell
az group create --name <resource group name> --location westeurope
```

Once you have created the resource group, create an Azure container registry. The container registry name must be unique within Azure.

```shell
az acr create --resource-group <resource group name> --name <acr name> --sku Basic
```

### Log in to container registry

You must log in to your container registry before pushing images to it.

```
az acr login --name <acr name>
```

### Tag container image

To push a container image to a private registry like Azure Container Registry, you must first tag the image with the full name of the registry's login server.
First get the full login server name for your Azure Container Registry.

```shell
az acr show --name <acr name> --query loginServer --output table
```

Now you can tag your image that must be pushed the Azure Container registry as follows:

```shell
docker tag blobtriggerfunction:0.1 <acrLoginServer>/blobtriggerfunction:0.1
```

Run docker images to see the new tagged image:

```
docker images
```

### Push the image to Azure Container Registry

Now you have tagged the _blobtriggerfunction:0.1_ image with the full login server name of your Azure Container registry and you can push it to the registry.

```shell
docker push <acrLoginServer>/blobtriggerfunction:0.1
```

### List images in Azure Container registry

To verify that the image was pushed to your Azure Container registry you can either validate it by browsing to the Azure portal or you can list the images in your Azure Container registry with Azure CLI:

```shell
az acr repository list --name <acr name> --output table
```

If you want to see the tags for the image, do the following:

```shell
az acr repository show-tags --name <acr name> --repository blobtriggerfunction --output table
```

### Access your Azure Container registry

When you want to deploy an image that is hosted in a private Azure Container registry you must supply credentials to access the registry.
A best practice is to create and configure an Azure Active Directory service principal with pull permission to your registry.

Another option is to use the Azure Container Registry's admin user name and password.

#### Service principal

If you want to get into using a service principal for accessing your Azure Container Registry tahe a look at the documentation [here](https://docs.microsoft.com/azure/container-registry/container-registry-auth-aci) and checkout the scripts to setup a service prinipal with pull permission to your Azure Container Registry.

#### Admin user

If you want to use Azure Container Registry's admin credential enable the admin user first:

```shell
az acr update --name <acr name> --admin-enabled true
```

After that you can query the admin credential:

```shell
az acr credential show --name <acr name>
```

### Deploy to Azure Container Instances

Now use the command _az container create_ to deploy the container. Use either the service principal id and password or the admin user name and password to access your Azure Container Registry.

```shell
az container create --resource-group <resource group name> --name blobtriggerfunction --image <acrLoginServer>/blobtriggerfunction:0.1 --cpu 1 --memory 1 --registry-login-server <acrLoginServer> --registry-username <sp id or admin> --registry-password <sp or admin password> --environment-variables StorageAccountConnectionString='<your storage connectionstring>' AzureWebJobsStorage='<your storage connectionstring>'
```

Within a few seconds you should receive an initial response from Azure. To view the state of the deployment, do the following:

```shell
az container show --resource-group <resource group name> --name blobtriggerfunction --query instanceView.state
```

### View application and container logs

Once the container is up and running view the log output of the container:

```shell
az container logs --resource-group TEST-FUNC-RG --name blobtriggerfunction
```

### See it in action

Now open Azure Storage Explorer again and upload some images to see the Azure function running in Azure Container Instances in action.

## Housekeeping
