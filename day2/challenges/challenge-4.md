# Azure Resource Manager (ARM) Templates #

## Here is what you will learn ##

- get to know the Azure Resource Manager and Resource Providers
- learn about how ARM templates are structured and what you can do with them
- create a basic template and deploy them via the Azure Portal
- deploy a complex infrastructure via ARM templates and Azure CLI

## Just to be on the same page... ##

Before we can get into Azure Resource Manager and the related templates, we need to clarify some terms:

- **Resource** – an element manageable via Azure. For example: a virtual machine, a database, a web app etc.
- **Resource Group** – a container for resources. A resource can not exist in Azure without a ResourceGroup (RG). Deployments of resources are always executed on an RG. Typically, resources with the same lifecycle are grouped into one resource group.
- **Resource Provider** – an Azure service for creating a resource through the Azure Resource Manager. For example, “Microsoft.Web” to create a web app, “Microsoft.Storage” to create a storage account etc.
- **Azure Resource Manager (ARM) Templates** – a JSON file that describes one or more resources that are deployed into a Resource Group. The template can be used to consistently and repeatedly provision the resources.

One great advantage when using ARM templates, is the **traceability** of changes to your infrastructure. Templates can be stored together with the **source code** of your application in the code repository (***Infratructure as Code***). If you have established Continuous Integration / Deployment in your development process (which we will do on ***Day 4***), you can execute the deployment of the infrastructure from Jenkins, TeamCity or Azure DevOps. No one has to worry about an update of the environment – web apps, databases, caches etc. will be created and configured automatically – no manual steps are necessary (which can be error-prone, as we all know).

## Azure Resource Manager ##

The Azure Resource Manager is the deployment and management service for Azure. It provides a management layer that enables you to create, update, and delete resources in your Azure subscription. 

You can access the resource manager through several ways:

- Azure Portal
- Azure Powershell
- Azure CLI
- plain REST Calls
- SDKs

![arm](./img/consistent-management-layer.png "arm")

As you can see in the picture above, the Resource Manager is made of several **Resource Providers** (RP) that are ultimately responsible for provisioning the requested service/resource. Resource providers can be independently enabled or disabled. To see, what RPs are active in your subscription, you can either check the Portal (Subscription --> Resource Providers) or use Azure CLI to query the resource manager:

```shell
$ az provider list -o table

Namespace                               RegistrationPolicy    RegistrationState
--------------------------------------  --------------------  -------------------
Microsoft.ChangeAnalysis                RegistrationRequired  Registered
Microsoft.EventGrid                     RegistrationRequired  Registered
Microsoft.Logic                         RegistrationRequired  Registered
Microsoft.Security                      RegistrationRequired  Registered
Microsoft.PolicyInsights                RegistrationRequired  Registered
Microsoft.AlertsManagement              RegistrationRequired  Registered
Microsoft.Advisor                       RegistrationRequired  Registered
Microsoft.Web                           RegistrationRequired  Registered
microsoft.insights                      RegistrationRequired  Registered
Microsoft.KeyVault                      RegistrationRequired  Registered
Microsoft.Storage                       RegistrationRequired  Registered
Microsoft.Portal                        RegistrationFree      Registered
Microsoft.DocumentDB                    RegistrationRequired  Registered
Microsoft.Search                        RegistrationRequired  Registered
Microsoft.Cdn                           RegistrationRequired  Registered
Microsoft.Cache                         RegistrationRequired  Registered
Microsoft.ResourceHealth                RegistrationRequired  Registered
Microsoft.Sql                           RegistrationRequired  Registered
...
...
...
```

![providers](./img/portal_resource_providers.png "providers")

### Basic Sample ###

If you deploy e.g. a Storage Account, the (relevant part of the) template for it looks like that:

```json
"resources": [
  {
    "type": "Microsoft.Storage/storageAccounts",
    "apiVersion": "2016-01-01",
    "name": "mystorageaccount",
    "location": "westus",
    "sku": {
      "name": "Standard_LRS"
    },
    "kind": "Storage",
    "properties": {}
  }
]
```

If you use the Portal or Azure CLI to apply that template, it will be converted to REST call like this:

``` 
PUT
https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/mystorageaccount?api-version=2016-01-01
REQUEST BODY
{
  "location": "westus",
  "sku": {
    "name": "Standard_LRS"
  },
  "kind": "Storage",
  "properties": {}
}
``` 

As you can see, deployments in Azure will always be executed against a **resource group**, as mentioned before! In this sample, the template will be ultimately picked-up by the **Microsoft.Storage** resource provider, which then will be responsible for creating a Storage Account for you.

## ARM Templates ##

So, you already now had a brief look how an ARM template looks like. Let's make a step back and show you how these templates are structured.

An ARM Template usually consists of several parts:

- **parameters** – Parameters that are passed from the outside to the template. Typically, from the commandline or your deployment tool (e.g. Terraform, Azure DevOps, Jenkins...)
- **variables** – variables for internal use. Typically, parameters are “edited”, e.g. names are concatenated and stored in variables for later use.
- **resources** – the actual resources to be created
- **outputs** – Output parameters that are returned to the caller after the template has been successfully applied. With *outputs* you can achieve multi-stage deployments by passing outputs to the next ARM template in your deployment chain.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "variables": {},
    "resources": [],
    "outputs": {}
}
```

## A Basic Template ##

So, to sticking to our sample from above (Storage Account), let's create a basic template that will create a Storage Account and makes use of a very helpful feature (*Template Functions*). Here it is:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "storageAccountName": {
            "type": "string",
            "metadata": {
                "description": "The name of the storage account to be created."
            }
        },
        "storageAccountType": {
            "type": "string",
            "defaultValue": "Standard_LRS",
            "allowedValues": [
                "Standard_LRS",
                "Standard_GRS",
                "Standard_ZRS",
                "Premium_LRS"
            ],
            "metadata": {
                "description": "Storage Account type"
            }
        }
    },
    "variables": {
    },
    "resources": [
        {
            "name": "[parameters('storageAccountName')]",
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2015-06-15",
            "location": "[resourceGroup().location]",
            "tags": {
                "displayName": "[parameters('storageAccountName')]"
            },
            "properties": {
                "accountType": "[parameters('storageAccountType')]"
            }
        }
    ],
    "outputs": {
        "storageAccountConnectionString": {
            "type": "string",
            "value": "[listKeys(resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName')), providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value]"
        }
    }
}
```

*Some notes on the template above:*

As you can see, we are able to use functions to do dynamic stuff within a template, e.g. reading keys (```listKeys()```) or using parameter (```parameters()```). There are, of course, other functions e.g. for string manipulation (*concatenate*, *padLeft*, *split*...), numeric functions, comparison functions, conditionals etc. You can find all available template functions and their documentation here: <https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions>

Please make yourself familiar with the list!

So now, let's deploy the template and see what we will receive as output (sample template is prepared in folder: *day2/challenges/armtemplates/basic*).

```shell
$ az group create -n basicarm-rg -l westeurope

$ az group deployment create -g basicarm-rg -n firsttemplate --template-file=./azuredeploy.json
Please provide string value for 'storageAccountName' (? for help): <ENTER_A_VALUE>
 - Running ...

 ```

 When the deployment has finished, you will receive a pretty large JSON output. But what's interesting, in the outputs section, you will receive the primary Storage Account Key (Note: all other parts have been omitted in terms of readability. Note2: the key is not valid anymore, so save yourself some time and don't even try ;)).

 ```json
 {
  "properties": {
    "outputs": {
      "storageAccountConnectionString": {
        "type": "String",
        "value": "TSYOb3JdAe6iBls6l3I73XIs4KfBVENARbs8IDzkTqVVVCgElH5wOtCJ61JN7AKBI/o0OkqBG0wkQWZy3FbHUg=="
      }
    }
  }
}
```

You sure have noticed that you were promted to enter a value for the parameter *storageAccountName*. In a fully automated deployment, this is not really acceptable. You can set the parameters either via CLI...

```shell 
$ az group deployment create -g basicarm-rg -n firsttemplate --template-file=./azuredeploy.json --parameters storageAccountName=adcmyarmsa
```

...or use a dedicated parameters file:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "storageAccountName": {
            "value": "adcmyarmsa"
        }
    }
}
```

You can supply the parameters file via the ```@```syntax:

```shell
az group deployment create -g basicarm-rg -n firsttemplate --template-file=./azuredeploy.json --parameters=@azuredeploy.params.json
```

Most people prefer the *parameters file*-approach, because you can set up parameter files for different environments, e.g. azuredeploy.params.**DEV**.json, azuredeploy.params.**TEST**.json, azuredeploy.params.**PROD**.json etc.

**Warning**: There exist two modes, how you can deploy an ARM template:

- **Complete** – resources that are not present in the template, but do exist in the resource group, are deleted.
- **Incremental** – resources that are not present in the template, but exist in the resource group, remain unchanged.

The default mode is *incremental*, so that you don't have to bother running *new* templates on existing resource groups. You can force to apply a template in *complete* mode by adding the parameter ```--mode Complete``` to the deployment command.

## Automatically set configuration properties in Web / Function Apps ##

Now that we can automatically deploy resources to Azure, we need to know how to, e.g., configure application settings of an Azure Web App during deployment. It's pretty easy, we now have all the tools to do so.

Let's add a Web App (plus AppService Plan) to our deployment to demonstrate it.

Here's the template:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "storageAccountName": {
            "type": "string",
            "metadata": {
                "description": "The name of the storage account to be created."
            }
        },
        "storageAccountType": {
            "type": "string",
            "defaultValue": "Standard_LRS",
            "allowedValues": [
                "Standard_LRS",
                "Standard_GRS",
                "Standard_ZRS",
                "Premium_LRS"
            ],
            "metadata": {
                "description": "Storage Account type"
            }
        },
        "hostingPlanName": {
            "type": "string",
            "metadata": {
                "description": "The name of the AppService Plan."
            }
        },
        "webAppName": {
            "type": "string",
            "metadata": {
                "description": "The name of the WebApp to be created."
            }
        }
    },
    "variables": {
    },
    "resources": [
        {
            "name": "[parameters('storageAccountName')]",
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2015-06-15",
            "location": "[resourceGroup().location]",
            "tags": {
                "displayName": "[parameters('storageAccountName')]"
            },
            "properties": {
                "accountType": "[parameters('storageAccountType')]"
            }
        },
        {
            "apiVersion": "2015-08-01",
            "name": "[parameters('hostingPlanName')]",
            "type": "Microsoft.Web/serverfarms",
            "location": "[resourceGroup().location]",
            "tags": {
                "displayName": "HostingPlan"
            },
            "sku": {
                "name": "B1",
                "capacity": 1
            },
            "properties": {
                "name": "[parameters('hostingPlanName')]"
            }
        },
        {
            "name": "[parameters('webAppName')]",
            "type": "Microsoft.Web/sites",
            "apiVersion": "2015-08-01",
            "location": "[resourceGroup().location]",
            "tags": {
                "displayName": "[parameters('webAppName')]"
            },
            "dependsOn": [
                "[resourceId('Microsoft.Web/serverfarms', parameters('hostingPlanName'))]",
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName'))]"
            ],
            "properties": {
                "name": "[parameters('webAppName')]",
                "serverFarmId": "[resourceId('Microsoft.Web/serverfarms', parameters('hostingPlanName'))]"
            },
            "resources": [
                {
                    "apiVersion": "2015-08-01",
                    "type": "config",
                    "name": "appsettings",
                    "properties": {
                        "STORAGE_ACCOUNT": "[listKeys(resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName')), providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value]"
                    },
                    "dependsOn": [
                        "[resourceId('Microsoft.Web/sites', parameters('webAppName'))]",
                        "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName'))]"
                    ]
                }
            ]
        }
    ],
    "outputs": {
        "storageAccountConnectionString": {
            "type": "string",
            "value": "[listKeys(resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName')), providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value]"
        }
    }
}
```

I'd like to point you attention to a few new things here. First and foremost, we defined **dependencies** in the template. Have a look at the *WebApp* resource.

```json
"dependsOn": [
    "[resourceId('Microsoft.Web/serverfarms', parameters('hostingPlanName'))]",
    "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName'))]"
]
```

We tell the Azure Resource Manager, that the **Azure Web App depends on other resources**. This has the effect, that the creation of the Web App will be postponed until the Storage Account and the AppService Plan have been created. This sure makes sense, because we want to read the Storage Account Key and put it into the Web App configuration settings:

```json
{
    "apiVersion": "2015-08-01",
    "type": "config",
    "name": "appsettings",
    "properties": {
        "STORAGE_ACCOUNT": "[listKeys(resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName')), providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value]"
    }
}
```

The template would fail, if we wouldn't add the the dependency, because the Azure Resource Manager will delegate the **provisioning of resources to the resource providers in parallel** (which is one of the advantages over Powershell or Azure CLI for resource creation - it will be done in parallel. With PS or Azure CLI the script/commands would be executed sequentially)! So, it would not wait until the Storage Account is present...the template would therefore throw an error as soon as the Storage Account Key would be read (from a resource that might not exist).

Deploy the ARM template via Azure CLI to a new resource group and check afterwards, if the Storage Account key is present in the Web App Configuration settings. Sample is prepared for you under: *day2/challenges/armtemplates/basicpluswebapp*.

![arm](./img/arm_deploy_basicplus.png "arm")

## Deploying a complex Infrastructure ##

Now that we have seen the basic structure of an ARM template and how we can deploy it, let's approch to a more complex sample. Here's an overview of what the template contains:

![arm](./img/arm_infra_large.png "arm")

You can find the ARM template and the correspondig parameters file in folder *day2/challenges/armtemplates/largeinfra*. Make yourself familiar with the template. Afterwards, create a new resource group, e.g. *complexarm-rg* and deploy the template.

While you are deploying the template (create a new resource group and apply the template), here are a few parts, you should hav a look at in the meantime:

- look at the template functions for concatenation, string manipulations like "replace"
- adding connection strings to Web Apps (which is different from App Settings)
- automatic Web App Slot creation
- Autoscale settings of Web Apps

When the deployment has finished, check your resource group and open the "Deployments" overview.

> If you wonder why this takes longer as expected: the Redis Cache is responsbile for the delay. But you usually deploy such a service once when setting up you infrastructure, so that should not be much of a problem. 

![arm](./img/arm_deploy_infra_large.png "arm")


## House Keeping ##

Remove the sample resource groups for the basic/basic+ and large infra services.

```shell
$ az group delete -n armbasic-rg
$ az group delete -n armbasicplus-rg
$ az group delete -n complexarm-rg
```