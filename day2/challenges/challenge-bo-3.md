# Break Out #3: Create the infrastructure for our sample app with ARM templates

So, this is our last Break-Out session for today. You will now have the challenge to create the ARM template for our SCM Contacts application and deploy it to Azure.

## Services

As a reminder, here is the architecture, we want to create:

![architecture_day2](./img/architecture_day2.png "architecture_day2")

### Services to be added

- **Contacts API**
  - _Azure Web App:_
    - Size: S1
    - make it accept only HTTPS traffic
- **Resources / Images API**
  - _Azure Storage Account:_
    - SKU: Local Redundant Storage
    - Kind: StorageV2
  - _Azure Web App:_
    - Size: S1
    - make it accept only HTTPS traffic
    - configure App Settings:
      - ImageStoreOptions\_\_StorageAccountConnectionString: <CONNECTIONSTRING_OF_STORAGEACCOUNT>
      - ImageStoreOptions\_\_ImageContainer: _rawimages_
      - ImageStoreOptions-\_\_ThumbnailContainer: _thumbnails_
      - StorageQueueOptions\_\_StorageAccountConnectionString: <CONNECTIONSTRING_OF_STORAGEACCOUNT>
      - StorageQueueOptions\_\_Queue: _thumbnails_
      - StorageQueueOptions\_\_ImageContainer: _rawimages_
      - StorageQueueOptions\_\_ThumbnailContainer: _thumbnails_
  - _Azure Function:_
    - Consumption Plan (!)
    - configure App Settings:
      - AzureWebJobsDashboard: <CONNECTIONSTRING_OF_STORAGEACCOUNT>
      - AzureWebJobsStorage: <CONNECTIONSTRING_OF_STORAGEACCOUNT>
      - StorageAccountConnectionString: <CONNECTIONSTRING_OF_STORAGEACCOUNT>
      - QueueName: _thumbnails_
      - FUNCTIONS*WORKER_RUNTIME: \_dotnet*
      - FUNCTIONS*EXTENSION_VERSION: *~2\_
      - ImageProcessorOptions\_\_StorageAccountConnectionString: <CONNECTIONSTRING_OF_STORAGEACCOUNT>
      - ImageProcessorOptions\_\_ImageWidth: _100_
- **Frontend / Single Page Application**
  - _Azure Storage Account:_
    - SKU: Local Redundant Storage
    - Kind: StorageV2
    - Static Website Hosting can't be enabled via ARM templates at the time of writing. Enable it via Azure CLI after the deployment: `az storage blob service-properties update --account-name <STORAGE_ACCOUNT_NAME> --static-website --index-document index.html --404-document index.html`. To show the URL for it, use: `az storage account show -n <STORAGE_ACCOUNT_NAME> --query "primaryEndpoints.web" --output tsv`

## TODO for You

Create one ARM template (plus parameters file) that contains all resources we need. Deploy the resources to a new resource group.

## References / Links

- You can access/see the current template/JSON of running resources via <https://resources.azure.com>. (That is a good starting point, when you want to know what UI setting influences which JSON parameter.)
- Azure Resource Manager Template Reference: <https://docs.microsoft.com/en-us/azure/templates/>
  - find documentation for all available properties of a service/resource
- Azure Quickstart Templates: <https://github.com/Azure/azure-quickstart-templates>
  - Azure Function App (Consumption Plan): <https://github.com/Azure/azure-quickstart-templates/tree/master/101-function-app-create-dynamic>
  - Basic Web App: <https://github.com/Azure/azure-quickstart-templates/tree/master/101-webapp-basic-windows>
  - Storage Account: <https://github.com/Azure/azure-quickstart-templates/tree/master/101-storage-account-create>

# Wrap-Up

**_Congratulations_**! You have just automated the deployment of an Azure infrastructure. The next step would be to also automatically deploy the Web Apps / SPA to your infrastructure. We will learn about that on **Day 4**, when we are talking about **Continuous Integration and Continuous Deployment (CI/CD)**. On **Day 3**, we will learn about some additional Azure services that we can add to our application, to be able to store data, search for it and to show you how to do service-to-service communication with a _microsoervice approach_.
