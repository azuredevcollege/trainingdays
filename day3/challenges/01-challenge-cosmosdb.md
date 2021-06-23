# Challenge 01: Cosmos DB

⏲️ *Est. time to complete: 45 min.* ⏲️

## Here is what you will learn 🎯

In this challenge you will learn how to:

- Create a Cosmos DB account
- Add data and query via the data explorer
- Learn about partitions and the effect of cross-partition queries
- Use the Cosmos DB change feed

## Table Of Contents

1. [Create a Comsos DB Account, Database and Containers](#create-a-comsos-db-account-database-and-containers)
2. [Add and query data](#add-and-query-data)
3. [Azure Samples](#azure-samples)
4. [Cleanup](#cleanup)

## Create a Comsos DB Account, Database and Containers

Before we start creating a database account in Azure, let's have a brief look at the resource model of Cosmos DB. It is made of the following objects:

- _Account_: manages one or more databases
- _Database_: manages users, permissions and containers
- _Container_: a schema-agnostic container of user-generated JSON items and JavaScript based stored procedures, triggers and user-defined-functions (UDFs)
- _Item_: user-generated document stored in a container

![Cosmos DB Resource Model](./images/cosmosdb/resourcemodel.png "Comsos DB Resource Model")

To create a Cosmos DB account, database and the corresponding containers we will use in this challenge, you have two options:

- [Azure Portal](#azure-portal)
- [Azure Bicep](#azure-bicep)

Both are decribed in the next chapters, choose only one of them.

:::tip
📝 The "Bicep" option is much faster, because it will create all the objects automatically at once. If you want to go with that one, please also have a look at the "Create View" in the portal to make yourself familiar with all the settings you can adjust for a Cosmos DB account, db and container.
:::

### Azure Portal

Go to the portal...

### Azure Bicep

You can run the following commands on your local machine or in the Azure Cloud Shell. If Azure Bicep isn't installed already, just do so via the Azure CLI:

```shell
$ az bicep install #only needed, if bicep isn't present in the environment

$ cd day3/challenges/cosmosdb

$ az group create --name rg-azdccosmos --location westeurope
{
  "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-azdccosmos",
  "location": "westeurope",
  "managedBy": null,
  "name": "rg-azdccosmos",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}

$ az deployment group create -f cosmos.bicep -g rg-azdccosmos
{
  "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-azdccosmos/providers/Microsoft.Resources/deployments/cosmos",
  "location": null,
  "name": "cosmos",
  ...
  ...
  ...
  ...
}
```

### Tips, Warnings, Detail Sections

::: tip
📝 You can add tips
:::

::: warning
⚠️ You can add warnings
:::

::: danger
🛑 This is a dangerous warning
:::

::: details
🔍 This is a details block that can be collapsed
:::

### Tables

| Name       | Value              |
| ---------- | ------------------ |
| Use tables | Sample description |
| Use tables | Sample description |
| Use tables | Sample description |
| Use tables | Sample description |

### Text Formatting

Dolor sit amet `inline code` sit amet **sit amet justo** donec enim diam vulputate ut pharetra sit amet aliquam id diam maecenas ultricies mi eget mauris pharetra *et ultrices neque* ornare aenean euismod elementum ***nisi quis eleifend*** quam adipiscing vitae proin sagittis nisl rhoncus mattis rhoncus urna neque viverra justo

### Images

Images must have an alt text and a title for accessibility

![Description of the Image - Alt Text / a11y](./images/placeholder.png "Image Title")

![Non-existent image - Alt Text / a11y](./images/placeholder-ne.png "Image Title")

### Source Code / Shell

Shell with output:

```shell
$ az group create --name myFirstWebApps-rg --location westeurope

{
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myFirstWebApps-rg",
  "location": "westeurope",
  "managedBy": null,
  "name": "myFirstWebApps-rg",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```

Just a command on the shell without(!) output ("$" sign omitted):

```shell
az group create --name myFirstWebApps-rg --location westeurope
```

JavaScript

```js
if (process.env.SCM_ENV && process.env.SCM_ENV.toLowerCase() != 'production') var env = require('dotenv').config();
const fastify = require('fastify')({
    logger: true
});

const eventEmitter = require('./events/emitter');
const messageBus = require('./events/messagebus');
const createdEvent = require('./events/created');
const updatedEvent = require('./events/updated');
const deletedEvent = require('./events/deleted');
const contactsListener = require('./events/contacts-listener');

const appInsights = require("applicationinsights");
```

JSON

```json
{
    "endpoint": "https://adcday3scmapi-dev.azurewebsites.net/",
    "resourcesEndpoint": "https://adcday3scmresourcesapi-dev.azurewebsites.net/",
    "searchEndpoint": "https://adcday3scmrsearchapi-dev.azurewebsites.net/",
    "reportsEndpoint": "https://adcday3scmvr-dev.azurewebsites.net",
    "enableStats": false,
    "aiKey": ""
}
```

C#

```csharp
using System;
using System.IO;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Processing;

namespace AzDevCollege.Function
{
    public static class BlobTriggerCSharp
    {
        [FunctionName(nameof(BlobTriggerCSharp))]
        public static void Run(
            [BlobTrigger("originals/{name}", Connection = "<REPLACE_WITH_NAME_OF_STORAGE_ACCOUNT>_STORAGE")]Stream myBlob, string name,
            [Blob("processed/proc_{name}", FileAccess.Write, Connection = "<REPLACE_WITH_NAME_OF_STORAGE_ACCOUNT>_STORAGE")] Stream outStream, ILogger log)
        {
            using (Image image = Image.Load(myBlob))
            {
                // Resize and rotate the image!
                image.Mutate(x => x.Resize(image.Width / 2, image.Height / 2));
                image.Mutate(x => x.Rotate(90));

                image.SaveAsJpeg(outStream);
            }
            log.LogInformation($"C# Blob trigger function Processed blob\n Name:{name} \n Size: {myBlob.Length} Bytes");
        }
    }
}
```

## Add and query data

Aliquam vestibulum morbi blandit cursus risus at ultrices mi tempus imperdiet nulla malesuada pellentesque elit eget gravida cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus mauris vitae ultricies leo integer malesuada nunc vel risus commodo viverra maecenas accumsan lacus vel facilisis volutpat est velit egestas dui

## Azure Samples

_Add some links to Azure samples that might be of interest, e.g.:_

Azure AppService code samples:

- <https://docs.microsoft.com/en-us/samples/browse/?expanded=azure&products=azure-app-service%2Cazure-app-service-web>

## Cleanup

_If resources can be deleted after the challenge, make the reader aware of it, e.g.:_

Remove the sample resource group via:

```shell
az group delete -n myFirstWebApps-rg
```

[◀ Previous challenge](./00-challenge-baseline.md) | [🔼 Day 3](../README.md) | [Next challenge ▶](./02-challenge-sql.md)
