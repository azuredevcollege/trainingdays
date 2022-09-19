# 💎 Breakout 1: Add data storage services to our sample application 💎

⏲️ _Est. time to complete: 90 min._ ⏲️

## Here is what you will learn 🎯

Now that we have made experience with Azure SQL DB, Azure CosmosDB and Azure (Cognitive) Search, it is time to add these services to our sample application.

In this challenge you will:

- use Azure SQL DB and CosmosDB to store objects from the application
- add an Azure Cognitive Search Instance
- make use of Azure Service Bus for messaging between the application services
- add additional application services

:::tip
📝 If you could not finish the breakout challenges of "Day 2", there is a [baseline deployment script](00-challenge-baseline.md) that will automatically deploy all necessary Azure services for you and put you in the position to start right away with this challenge.
:::

## Table Of Contents

1. [Introduction](#introduction)
2. [Setup Data Storage Services](#setup-data-storage-services)
3. [Setup Messaging Services](#setup-messaging-services)
4. [Quality Check](#quality-check)
5. [Re-deploy Contacts/Resources Service and Image Resizer Function](#re-deploy-contactsresources-service-and-image-resizer-function)
6. [Deploy the Contacts Search Service](#deploy-the-contacts-search-service)
7. [Deploy the Visit Reports Service](#deploy-the-visit-reports-service)
8. [Deploy the Frontend](#deploy-the-frontend)
9. [Wrap-Up](#wrap-up)

## Introduction

At the end of the day, the architecture will look like this:

![Architecture Day 3 - Breakout 1](./images/architecture_day3breakout.png 'Architecture Day 3 - Breakout 1')

As you can see, we will introduce a new microservice (with its own data store - Cosmos DB) called "Visit Reports", that allows us to add visit reports to existing contacts. We will have a _1-to-many_ relation between _Contacts_ and _Visit Reports_. And, to have the Visit Reports service being able to work on its own, it will also store some data coming from the _Contacts_ service. So there will be some kind of duplication of data, which - in a microservice approach - is not an unusual thing.

The services interact via the Azure Service Bus (Producer/Consumer pattern) and exchange data, when events occurs in e.g. the _Contacts_ service.

The advantage is, that the services aren't tied together via REST calls and can work and be scaled independently. If we would introduce another service in the future that needs information from a contact, we would simply introduce another consumer for the _Contacts_ topic.

In addition, we will also be migrating the Storage Queue services (for image resizing) to Azure Service Bus Queues so that we only have one messaging component in our architecture.

The frontend will also change, as we introduce a new service:

![Application Day 3 #1](./images/scm_day3.png 'Application Day 3 #1')
![Application Day 3 #2](./images/scm_day3_vr.png 'Application Day 3 #2')
![Application Day 3 #3](./images/scm_day3_search.png 'Application Day 3 #3')

## Setup Data Storage Services

First of all, we now add an Azure SQL DB, Cosmos DB and an Azure Search service for the application.

### SQL DB

Create a new Azure SQL DB either via the Azure Portal or Azure CLI.

Database Properties:

| Parameter           | Value                                                                                                        |
| ------------------- | ------------------------------------------------------------------------------------------------------------ |
| _Resource group_    | use your existing resource group: **scm-breakout-rg**                                                        |
| _Compute + storage_ | Basic tier                                                                                                   |
| _Location_          | West Europe                                                                                                  |
| _Server_            | Create a new server in West Europe                                                                           |
| _Networking Tab_    | _Connectivity => Public_ <br> **Allow Azure services and resources to access this server** is set to **YES** |

Leave all other settings as proposed by Azure.

:::tip
📝 You can proceed with the next step while the Azure SQL DB is being created.
:::

![Azure SQL Database](./images/bo_data_sql.png 'Azure SQL Database')

### Cosmos DB / SQL API

Create a new Azure Cosmos Account either via the Azure Portal or Azure CLI.

Account Properties:

| Parameter        | Value                                                    |
| ---------------- | -------------------------------------------------------- |
| _Resource group_ | use your existing resource group: **scm-breakout-rg**    |
| _API_            | Core SQL                                                 |
| _Location_       | West Europe                                              |
| _Capacity mode_  | **OPTIONAL** - if you want to, you can choose Serverless |

:::tip
📝 The `Serverless` option is a perfect fit for development environments and small applications. You can find out more about the deployment option here: <https://docs.microsoft.com/azure/cosmos-db/throughput-serverless>
:::

Leave all other settings as proposed by Azure.

![Azure CosmosDB Account](./images/bo_data_cosmos.png 'Azure CosmosDB Account')

When the deployment has finished (creating the account takes some time - you can grab a coffee), create a new _Database_ and _Container_ under "Data Explorer" in the portal for the Visit Reports microservice.

Database Properties:

| Parameter                       | Value                                                                   |
| ------------------------------- | ----------------------------------------------------------------------- |
| _Database ID_                   | _scmvisitreports_                                                       |
| _Provision Database Throughput_ | true (not neccessary, if you chose to enable _Serverless_ mode)         |
| _RU/s_                          | Manual / 400 (not neccessary, if you chose to enable _Serverless_ mode) |

Container Properties:

| Parameter      | Value           |
| -------------- | --------------- |
| _Database ID_  | scmvisitreports |
| _Container ID_ | visitreports    |
| _Partition_    | /type           |

![Azure CosmosDB Data Explorer](./images/bo_data_cosmos2.png 'Azure CosmosDB Data Explorer')

### Azure Cognitive Search

Create a new Azure Cognitive Search Account either via the Azure Portal or Azure CLI.

Account Properties:

| Parameter        | Value                                                                    |
| ---------------- | ------------------------------------------------------------------------ |
| \_Resource Group | use your existing resource group: **scm-breakout-rg**                    |
| _Location_       | West Europe                                                              |
| _Pricing Tier_   | Free*(for development purposes - if that is not possible, choose_Basic*) |

Leave all other settings as proposed by Azure.

![Azure Cognitive Search](./images/bo_data_search.png 'Azure Cognitive Search')

## Setup Messaging Services

Create a new Azure Service Bus either via the Azure Portal or Azure CLI.

Service Bus Properties:

| Parameter        | Value                                                 |
| ---------------- | ----------------------------------------------------- |
| _Resource Group_ | use your existing resource group: **scm-breakout-rg** |
| _Pricing Tier_   | Standard                                              |
| _Location_       | West Europe                                           |

Leave all other settings as proposed by Azure.

### Service Bus Queue

When the deployment of the new Service Bus has finished, we need to add a Service Bus **Queue**. The queue will replace the Storage Account Queue we used to notify an Azure Function that creates thumbnails of contact images.

Service Bus Queue Properties:

- Name: _sbq-scm-thumbnails_

When successfully added, go to **Shared Access Policies** of the **Service Bus Queue (!)** and add two policies:

- Name: _listen_ (enable checkbox **Listen**)
  - will be used by clients that only need to listen to the Service Bus Queue
- Name: _send_ (enable checkbox **Send**)
  - will be used by clients that also need to be able to send messages to the Service Bus Queue

Our producers/consumers will use these Access Policies to be able to send and listen to/on that specific queue.

### Service Bus Topic for Contacts

We also nee a topic for handling _Contacts_ changes (create, update etc.) with corresponding subscriptions. Go back to the Service Bus Namespace in the Portal and add a new topic.

Contacts Topic Properties:

- Name: _sbt-contacts_

Leave all other settings as suggested and click **Create**. When finished, open the topic and add two subscriptions.

Subscription for Search Service / indexing of contacts:

| Parameter            | Value                                                         |
| -------------------- | ------------------------------------------------------------- |
| _Name_               | contactsearch                                                 |
| _Max delivery count_ | 10                                                            |
| _Enable Sessions_    | true (in this sample, we will be using Service Bus sessions!) |

:::tip
📝 `Sessions` enable the first-in, first out (FIFO) pattern within Azure Service Bus. If you want to know more about it, have a look at the official docs: <https://docs.microsoft.com/azure/service-bus-messaging/message-sessions>
:::

Subscription for Visit Reports Service

| Parameter            | Value        |
| -------------------- | ------------ |
| _Name_               | visitreports |
| _Max delivery count_ | 10           |
| _Enable Sessions_    | false        |

When you have successfully added the two subscriptions, go back to **Shared Access Policies** of the Service Bus Topic **sbt-contacts** and add two policies:

- Name: _listen_ (enable checkbox **Listen**)
  - will be used by clients that only need to listen to the Service Bus Topic
- Name: _send_ (enable checkbox **Send**)
  - will be used by clients that also need to be able to send messages to the Service Bus Topic

### Service Bus Topic for Visit Reports

We also need a topic for handling _Visit Report_ changes (create, update etc.). Go back to the Service Bus Namespace in the Portal and add a new topic.

Visit Reports Topic Properties:

- Name: _sbt-visitreports_

Leave all other settings as suggested and click **Create**.

When successfully added, go back to **Shared Access Policies** of the Service Bus Topic **sbt-visitreports** and add two policies:

- Name: _listen_ (enable checkbox **Listen**)
  - will be used by clients that only need to listen to the Service Bus Topic
- Name: _send_ (enable checkbox **Send**)
  - will be used by clients that also need to be able to send messages to the Service Bus Topic

We don't add a subscription for the _visit report_ topic at the moment. The topic will be used later when we integrate further services like Azure Congitive Services.

## Quality Check

You should have created the following Azure services by now:

- [Azure SQL DB](#sql-db)
- [Azure Cosmos DB (database + container)](#cosmos-db--sql-api)
- [Azure Cognitive Search](#azure-cognitive-search)
- [Azure Service Bus](#setup-messaging-services)
  - [Queue for thumbnail generation](#service-bus-queue)
    - Shared Access Policies for _listen_ and _send_
  - [Topic for Contacts](#service-bus-topic-for-contacts)
    - Shared Access Policies for _listen_ and _send_
    - subscription for visit reports
    - subscription for search service
  - [Topic for Visit Reports](#service-bus-topic-for-visit-reports)
    - Shared Access Policies for _listen_ and _send_

If you missed to create one of these services, please click on the corresponding link and go back the specific section.

## Re-deploy Contacts/Resources Service and Image Resizer Function

Because we refactored the **Contacts** and **Resources APIs** to use **Azure Service Bus** for inter-service communication, we need to deploy new versions of these application services and change some of the App Configuration/Settings we added on **Day 2**.

:::tip
📝 We will be re-using the Azure service instances from **Day 2**!
:::

### Alter App Configuration/Settings

We will **reuse the Web Apps for Contacts and Resources** as well as the Azure Function for image manipulation we created yesterday. So, first we will adjust the App Configuration for each of the services.

:::tip
📝 Use a second browser window/tab to be able to switch back and forth while adding the configuration settings.
:::

Azure Web App for **Contacts Service**:

Application Configuration/Settings:

| Parameter                                         | Value / Hint                                                                                                     |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| EventServiceOptions\_\_ServiceBusConnectionString | use the Connection String from the Shared Access Policy (**Topic sbt-contacts**) for sending messages - **send** |

Connection Strings:

| Parameter               | Value / Hint                                                                                                                                                                            | Type       |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| DefaultConnectionString | go to the Azure SQL DB you created and use the ADO.NET connection string (under "**Settings**" / "**Connection strings**"). Don't forget to add your password to the connection string! | _SQLAzure_ |

![Contacts API Configuration Settings](./images/portal_bo_adjust_contactsapi.png 'Contacts API Configuration Settings')

Azure Web App for **Resources Service**:

Application Settings:

| Parameter                                                | Value / Hint                                                                                                            |
| -------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| ImageStoreOptions\_\_ThumbnailContainer                  | _thumbnails_                                                                                                            |
| ImageStoreOptions\_\_ImageContainer                      | _rawimages_                                                                                                             |
| ImageStoreOptions\_\_StorageAccountConnectionString      | use the **Connection String** from your Storage Account created in the Break Out session yesterday (should be the same) |
| ServiceBusQueueOptions\_\_ImageContainer                 | _rawimages_                                                                                                             |
| ServiceBusQueueOptions\_\_ThumbnailContainer             | _thumbnails_                                                                                                            |
| ServiceBusQueueOptions\_\_ThumbnailQueueConnectionString | use the Connection String from the Shared Access Policy (**Queue sbq-scm-thumbnails**) for sending messages - **send**  |

:::tip
📝 You can delete all **StorageQueueOptions\_\_** app settings!
:::

![Resources API Configuration Settings](./images/portal_bo_adjust_resapi.png 'Resources API Configuration Settings')

Azure Function for **Image Manipulation / Resizer Service**:

Configuration / Application Settings:

| Parameter                                               | Value / Hint                                                                                                                                                                                                                                                                        |
| ------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ServiceBusConnectionString                              | use the Connection String from the Shared Access Policy (**Queue sbq-scm-thumbnails**) for listening for messages - **listen** <br><br><span style="color:red">**Important**</span>: Please remove the _EntityPath_ variable (incl. the value) at the end of the connection string! |
| ImageProcessorOptions\_\_ImageWidth                     | _100_                                                                                                                                                                                                                                                                               |
| ImageProcessorOptions\_\_StorageAccountConnectionString | use the **Connection String** from your Storage Account created in the Break Out session yesterday (should be the same)                                                                                                                                                             |

:::tip
📝 You can delete the **QueueName** app settings!
:::

![Adjust Configuration Settings](./images/portal_bo_adjust_imgmanipulation.png 'Adjust Configuration Settings')

### Redeploy the services for Contacts, Resources and Image Manipulation

First of all: as seen in the Break Out session yesterday, everything is pre-created for you...this time, you need to open VS Code with the prepared workspace for **Day 3 / Breakout 1** (`day3/day3-breakout1.code-workspace`).

The folder structure looks as follows:

![Visual Studio Code Workspace for Day 3 / Breakout 1](./images/bo1_code.png 'Visual Studio Code Workspace for Day 3 / Breakout 1')

You will see additional projects added to the workspace compared to `Breakout 2` of **Day 2**:

- **Search API** - contains the backend logic for searching for _contacts_ objects via Azure Cognitive Search
- **Search Indexer Function** - contains the Azure Function to index contacts when a contact object has been created/updated
- **Visit Reports API** - contains the backend logic for managing _visitreport_ objects

For now, we don't need to deal with the added projects. We simply redeploy the existing ones. You have deployed web apps and functions several times yesterday, so you should be familiar with the process.

So please re-deploy the Web Apps/Functions for:

- Contacts API
- Resources API
- Image Resizer Function

![Projects That Need To Be Re-Deployed](./images/bo1_redeploy.png 'Projects That Need To Be Re-Deployed')

:::warning
⚠️ Please make sure you use the versions from the "Day3 - Breakout 1 Workspace"! Double-check that you use the correct VS Code workspace. The services have also been adjusted on the code level.
:::

## Deploy the Contacts Search Service

To be able to run the Contacts Search service (where we leverage the core functionality of Azure Search), we first need an Azure Web App to host it. So, please go to the Portal (or use the Azure CLI) and create an Azure Web App (with a new Azure AppService Plan on Windows, Runtime **.NET 6**) - use SKU / Size **S1**.

When finished, apply these settings to the Web App Configuration settings:

| Parameter                           | Value / Hint                                                                                                                                          |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| ContactSearchOptions\_\_AdminApiKey | use the Primary Admin Key from Azure Search (under **Settings / Keys**)                                                                               |
| ContactSearchOptions\_\_IndexName   | _scmcontacts_                                                                                                                                         |
| ContactSearchOptions\_\_ServiceName | the name of your previously created Azure Search (just the subdomain! So from <https://adcd3search-dev.search.windows.net>, only **adcd3search-dev**) |

![Search API Configuration Settings](./images/portal_bo_add_search.png 'Search API Configuration Settings')

**Time to deploy the Contacts Search** (folder _Search API_ in VS Code) service to the newly created Azure AppService. Please deploy that service like you did with the Contacts API or Resources API (via right-click-deployment from within VS Code).

### Create and deploy the Contacts Search Indexer Function

Now we have deployed an Azure Search Service and an API that is able to query the search index. But how will contacts be pushed to the Azure Search index? Therefore, we will be using another Azure Function that listens to created and changed contacts via an Azure Service Bus Topic (**sbt-contacts**, you already created it - as well as the corresponding subscription **contactsearch**)!

Create the Azure function in the **scm-breakout-rg** resource group with the follwing parameters:

| Parameter       | Value / Hint                                                       |
| --------------- | ------------------------------------------------------------------ |
| Publish         | _Code_                                                             |
| Runtime         | _.NET_                                                             |
| Version         | _6_                                                                |
| Region          | _West Europe_                                                      |
| OS              | _Windows_                                                          |
| Storage Account | Use the storage account you created in the breakout resource group |
| Plan Type       | _Consumption_                                                      |

When finished, apply these settings to the App Configuration settings:

| Parameter                            | Value / Hint                                                                                                                                                                                                                                                                                        |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ContactIndexerOptions\_\_AdminApiKey | use the Primary Admin Key from Azure Search (under **Settings / Keys**)                                                                                                                                                                                                                             |
| ContactIndexerOptions\_\_IndexName   | _scmcontacts_                                                                                                                                                                                                                                                                                       |
| ContactIndexerOptions\_\_ServiceName | the name of your previously created Azure Search (just the subdomain! So from <https://adcd3search-dev.search.windows.net>, only **adcd3search-dev**)                                                                                                                                               |
| ServiceBusConnectionString           | use the Service Bus Connection String from the Shared Access Policy (**Topics** / **sbt-contacts**) for listening for messages - **listen**. <br><br><span style="color:red">**Important**</span>: Please remove the **EntityPath** variable (incl. the value) at the end of the connection string! |

![Search Indexer Function Configuration Settings](./images/portal_bo_add_searchindexer.png 'Search Indexer Function Configuration Settings')

**Last but not least**, deploy the Contacts Search indexer function (folder _Search Indexer Function_) service from VS Code to the previously created Function App.

## ⏸️ Let's press "Pause" for a moment - What have we done so far?

The was a lot of manual typing so far, so let's hold on for a moment. We have just migrated our initial services (Contacts and Resources, Image Resizer) to Azure Service Bus Queues and Topics. We redeployed new versions of these services to make use of Azure Service Bus. We also added Storage Services to our application. The Contacts Service now uses Azure SQL DB.

In addition, we added an Azure Search service (incl. indexer function) plus an API that is able to talk to Azure Search and query for contacts. The contacts will be added / updated in the search index "on-the-fly" whenever a contact is changed/created - notification is done via Service Bus Topics.

Regarding our architecture, we are at this stage:

![Architecture Breakout 1](./images/architecture_day3breakout1.png 'Architecture Breakout 1')

Now, let's add the Visit Reports API.

## Deploy the Visit Reports Service

To deploy the Visit Reports API, we - as usual - need another Web App. As this service runs on NodeJS and we want to leverage **Azure Web Apps on Linux** this time, let's create one that is backed by a Linux OS.

**Azure WebApp Properties**

Create the Linux Web App with the following parameters.

| Parameter        | Value / Hint                               |
| ---------------- | ------------------------------------------ |
| Resource Group   | **scm-breakout-rg**                        |
| Publish          | _Code_                                     |
| Runtime Stack    | _Node 14 LTS_                              |
| App Service Plan | Create a new one: OS - _Linux_, SKU - _S1_ |

![Visit Reports API AppService](./images/day3_bo_tux_vr.png 'Visit Reports API AppService')

When the Web App has been created, go to the Configuration section and add the following settings (App settings + Connection strings!).

**Azure Web App / Configuration / Application Settings**

| Parameter       | Value                                                                                  |
| --------------- | -------------------------------------------------------------------------------------- |
| APPINSIGHTS_KEY | \<empty>                                                                               |
| COSMOSDB        | the endpoint to the Cosmos DB, e.g. <https://adcd3cosmos-dev.documents.azure.com:443/> |

**Azure Web App / Configuration / Connection Strings**

| Parameter               | Value                                                                                                | Type     |
| ----------------------- | ---------------------------------------------------------------------------------------------------- | -------- |
| COSMOSKEY               | Primary Key of your Cosmos DB                                                                        | _Custom_ |
| SBCONTACTSTOPIC_CONNSTR | Primary Connection String of the Service Bus **Contacts** Topic (**sbt-contacts** / _listen_)        | _Custom_ |
| SBVRTOPIC_CONNSTR       | Primary Connection String of the Service Bus **Visit Reports** Topic (**sbt-visitreports** / _send_) | _Custom_ |

![Visit Reports API Configuration Settings](./images/portal_bo_add_vr.png 'Visit Reports API Configuration Settings')

Now, from an infrastructure point of view, we are ready to deploy the NodeJS app. Right-click on the folder `Visit Reports API`, select the correct Azure AppService and confirm the deployment to it.

:::tip
📝 While deploying to the AppService, Azure will run `npm install` for you, so you don't need to do this upfront. This will keep the amount of data sent to Azure quite small and reduces the deployment duration significantly! The technology working behind the scenes is called `Oryx`. If you want to know more about it and how to configure builds during deployment, this is the way to the GitHub repository: <https://github.com/microsoft/Oryx>

Oryx configuration: <https://github.com/microsoft/Oryx/blob/master/doc/configuration.md#oryx-configuration>
:::

In the output window, watch how the NodeJS app is copied to the Web App and is being started by Azure.

You can check, if it's running correctly by opening a browser window and point it to the following URL:

<https://YOUR_WEB_APP_NAME.azurewebsites.net/docs>

::: warning
⚠️ You will see the Swagger UI of the visit reports service - in the **Explore** textbox, replace **json** with **yaml** to view all operations.
:::

![Visit Reports API Swagger Definition](./images/day3_bo_tux_vr_swagger.png 'Visit Reports API Swagger Definition')

## Deploy the Frontend

Now that we have introduced a few new services, we also need to redeploy the VueJS frontend. Of course, we also added a few changes in the UI itself (please see the intro section). So we definetly want that new version running now in Azure.

Open the `settings.js` file in folder _Frontend_ --> _public/settings_ and adjust the settings to fit the URLs of your Web Apps. You will need:

| Parameter         | Value                                                                                            |
| ----------------- | ------------------------------------------------------------------------------------------------ |
| endpoint          | URL of the contacts API endpoint, e.g. <https://adcday3scmapi-dev.azurewebsites.net/>            |
| resourcesEndpoint | URL of the resources API endpoint, e.g. <https://adcday3scmresourcesapi-dev.azurewebsites.net/>  |
| searchEndpoint    | URL of the search API endpoint, e.g. <https://adcday3scmrsearchapi-dev.azurewebsites.net/>       |
| reportsEndpoint   | URL of the visit reports API endpoint, e.g. <https://adcday3scmvr-dev.azurewebsites.net>         |
| enableStats       | false (we will be adding statistics when we introduced Cognitive Services in the next challenge) |
| aiKey             | "" (just leave it empty)                                                                         |

**Sample:**

```json
var uisettings = {
    "endpoint": "https://adcday3scmapi-dev.azurewebsites.net/",
    "resourcesEndpoint": "https://adcday3scmresourcesapi-dev.azurewebsites.net/",
    "searchEndpoint": "https://adcday3scmrsearchapi-dev.azurewebsites.net/",
    "reportsEndpoint": "https://adcday3scmvr-dev.azurewebsites.net",
    "enableStats": false,
    "aiKey": ""
}
```

After you have adjusted the settings, open an **integrated terminal** in VS Code for folder _Frontend_ and run...

```shell
npm install && npm run build
```

The VueJS app is built into folder _dist_ of the `Frontend` directory. When the build has finished, right-click on that `dist` folder and choose "Deploy to Static Website via Azure Storage" and select the correct storage account.

When everything is set up correctly and the services work as expected, you should be able to open the SPA and test the Contacts and Visit Reports services, as well as the Search service.

Add and edit a few new contacts (search for them via the top navigation bar) and create some visit reports for them.

![SCM Contacts List](./images/scm_day3.png 'SCM Contacts List')
![Visit Report Detail](./images/scm_day3_vr.png 'Visit Report Detail')

# Wrap-Up

So, we know, this was a lot of manual work to do, to add a simple microservice-oriented application to Azure. There are a lot of moving parts in that kind of applications and you will want to avoid deploying such applications manually. That's why we will be introducing Azure DevOps on Day 4, so that you can build and deploy the infrastructure as well as the services automatically.
Anyway, we wanted to show you how it's done "the hard way" to bring you relief the day after.

We now have one more challenge to complete (Cognitive Services), until the application is finished from a services perspective.

In this Breakout Challenge, you made use of:

- [Azure SQL DB](https://docs.microsoft.com/azure/azure-sql/)
- [Azure CosmosDB](https://docs.microsoft.com/azure/cosmos-db/)
- [Azure Service Bus](https://docs.microsoft.com/azure/service-bus-messaging/)
- [Azure Cognitive Search](https://docs.microsoft.com/azure/search/)
- [Azure AppServices on Linux](https://docs.microsoft.com/azure/app-service/)

[◀ Previous challenge](./03-challenge-search.md) | [🔼 Day 3](../README.md) | [Next challenge ▶](./05-challenge-cognitive-services.md)
