# Challenge n: Name or Brief Description

⏲️ *Est. time to complete: xx min.* ⏲️

## Here is what you will learn 🎯

In this challenge you will learn how to:

- ...
- ...
- ...

## Table Of Contents

1. [Topic A](#topic-a)
2. [Topic B](#topic-b)
3. [Azure Samples](#azure-samples)
4. [Cleanup](#cleanup)

## Topic A

laoreet sit amet cursus sit amet dictum sit amet justo donec enim diam vulputate ut pharetra sit amet aliquam id diam maecenas ultricies mi eget mauris pharetra et ultrices neque ornare aenean euismod elementum nisi quis eleifend quam adipiscing vitae proin sagittis nisl rhoncus mattis rhoncus urna neque viverra justo

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

## Topic B

Aliquam vestibulum morbi blandit cursus risus at ultrices mi tempus imperdiet nulla malesuada pellentesque elit eget gravida cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus mauris vitae ultricies leo integer malesuada nunc vel risus commodo viverra maecenas accumsan lacus vel facilisis volutpat est velit egestas dui

## Azure Samples

_Add some links to Azure samples that might be of interest, e.g.:_

Azure AppService code samples:

- <https://docs.microsoft.com/samples/browse/?expanded=azure&products=azure-app-service%2Cazure-app-service-web>

## Cleanup

_If resources can be deleted after the challenge, make the reader aware of it, e.g.:_

Remove the sample resource group via:

```shell
az group delete -n myFirstWebApps-rg
```

[◀ Previous challenge](./challenge-n-1.md) | [🔼 Day x](../README.md) | [Next challenge ▶](./challenge-bo-n.md)
