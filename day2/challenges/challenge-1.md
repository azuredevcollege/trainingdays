# Challenge 1 - Azure Web Apps

## Here is what you will learn

- Create an AppService Plan / Azure Web App
- Create and deploy an ASP.NET Core Web App to Azure
- Create and configure WebApp slots
- Use slots to deploy new versions of your web application with near-zero downtime

## Create an Azure Web App

### Option 1: Azure Portal

To create an Azure Web App, go to the Azure Portal and click on **"Create a resource"**, in the next view choose **"Web App"**.

![create](./img/portal_createresources.png "create")

When you reached the "Create Web App" wizard, follow the steps below:

- Choose the correct subscription
- Create a new resource group, name it "myFirstWebApps-rg"
- Under instance details, enter a name for your Web App (be careful: this must be a global unique name!)
- Publish: Code
- Runtime: .NET Core 3.1 (LTS)
- Operation System: Windows
- Region: West Europe
- create a new AppSerice plan
  - SKU and Size: S1
  - To get familiar with other sizes, click "Change size"

Click "Next: Monitoring".

- Enable AppInsights
- Create a new AppInsights instance for it

When done, proceed to the "Review + create" screen.

![review](./img/portal_webapp.png "review")

Again, check that all the properties are filled with the expected values and click "Create".

When the deployment has finished, got to the resource and get familiar with all the configuration options discussed in the introduction talk.

![overview](./img/portal_webappoverview.png "overview")

Open the web app in your browser.

![browser](./img/browser_webapp.png "browser")

### Option 2: Azure CLI

If you have created the web application already with option 1, go to the portal and delete the resource group - including all the newly created resources (you have to wait until it has finished, before proceeding). We will be creating the exact same resources now with the Azure CLI.

First, let's create the resource group.

> BTW: You can check the results of each command in the Portal.

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

Next, add an App Service Plan.

```shell
$ az appservice plan create -g myFirstWebApps-rg -n myFirstWebAppsPlan --sku S1

{
  "freeOfferExpirationTime": null,
  "geoRegion": "West Europe",
  "hostingEnvironmentProfile": null,
  "hyperV": false,
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myFirstWebApps-rg/providers/Microsoft.Web/serverfarms/myFirstWebAppsPlan",
  "isSpot": false,
  "isXenon": false,
  "kind": "app",
  "location": "West Europe",
  "maximumElasticWorkerCount": 1,
  "maximumNumberOfWorkers": 10,
  "name": "myFirstWebAppsPlan",
  "numberOfSites": 0,
  "perSiteScaling": false,
  "provisioningState": "Succeeded",
  "reserved": false,
  "resourceGroup": "myFirstWebApps-rg",
  "sku": {
    "capabilities": null,
    "capacity": 1,
    "family": "S",
    "locations": null,
    "name": "S1",
    "size": "S1",
    "skuCapacity": null,
    "tier": "Standard"
  },
  "spotExpirationTime": null,
  "status": "Ready",
  "subscription": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tags": null,
  "targetWorkerCount": 0,
  "targetWorkerSizeId": 0,
  "type": "Microsoft.Web/serverfarms",
  "workerTierName": null
}
```

When the App Service Plan has been created, we can now add the Web App.

```shell
$ az webapp create -g myFirstWebApps-rg -p myFirstWebAppsPlan -n myFirstWebAppDevCollege

{
  "availabilityState": "Normal",
  "clientAffinityEnabled": true,
  "clientCertEnabled": false,
  "clientCertExclusionPaths": null,
  "cloningInfo": null,
  "containerSize": 0,
  "dailyMemoryTimeQuota": 0,
  "defaultHostName": "myfirstwebappdevcollege.azurewebsites.net",
  "enabled": true,
  "enabledHostNames": [
    "myfirstwebappdevcollege.azurewebsites.net",
    "myfirstwebappdevcollege.scm.azurewebsites.net"
  ],
  "ftpPublishingUrl": "ftp://waws-prod-am2-217.ftp.azurewebsites.windows.net/site/wwwroot",
  "geoDistributions": null,
  "hostNameSslStates": [
    {
      "hostType": "Standard",
      "ipBasedSslResult": null,
      "ipBasedSslState": "NotConfigured",
      "name": "myfirstwebappdevcollege.azurewebsites.net",
      "sslState": "Disabled",
      "thumbprint": null,
      "toUpdate": null,
      "toUpdateIpBasedSsl": null,
      "virtualIp": null
    },
    {
      "hostType": "Repository",
      "ipBasedSslResult": null,
      "ipBasedSslState": "NotConfigured",
      "name": "myfirstwebappdevcollege.scm.azurewebsites.net",
      "sslState": "Disabled",
      "thumbprint": null,
      "toUpdate": null,
      "toUpdateIpBasedSsl": null,
      "virtualIp": null
    }
  ],
  "hostNames": [
    "myfirstwebappdevcollege.azurewebsites.net"
  ],
  "hostNamesDisabled": false,
  "hostingEnvironmentProfile": null,
  "httpsOnly": false,
  "hyperV": false,
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myFirstWebApps-rg/providers/Microsoft.Web/sites/myFirstWebAppDevCollege",
  "identity": null,
  "inProgressOperationId": null,
  "isDefaultContainer": null,
  "isXenon": false,
  "kind": "app",
  "lastModifiedTimeUtc": "2020-01-13T13:17:15.623333",
  "location": "West Europe",
  "maxNumberOfWorkers": null,
  "name": "myFirstWebAppDevCollege",
  "outboundIpAddresses": "137.117.218.101,137.117.210.101,137.117.214.210,137.117.214.88,137.117.212.13",
  "possibleOutboundIpAddresses": "137.117.218.101,137.117.210.101,137.117.214.210,137.117.214.88,137.117.212.13,137.117.208.108,137.117.208.41,137.117.211.152",
  "redundancyMode": "None",
  "repositorySiteName": "myFirstWebAppDevCollege",
  "reserved": false,
  "resourceGroup": "myFirstWebApps-rg",
  "scmSiteAlsoStopped": false,
  "serverFarmId": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myFirstWebApps-rg/providers/Microsoft.Web/serverfarms/myFirstWebAppsPlan",
  "siteConfig": null,
  "slotSwapStatus": null,
  "state": "Running",
  "suspendedTill": null,
  "tags": null,
  "targetSwapSlot": null,
  "trafficManagerHostNames": null,
  "type": "Microsoft.Web/sites",
  "usageState": "Normal"
}
```

The last step we need to have the same environment like when we created everything via the portal, is to add Application Insights.

The Azure CLI Application Insights component is still in preview. To access it, you first need to run:

```shell
$ az extension add -n application-insights

The installed extension 'application-insights' is in preview.
```

Now, let's create the AppInsights component for our application.

```shell
$ az monitor app-insights component create --app myFirstWebAppsAppIn --location westeurope --kind web -g myFirstWebApps-rg  --application-type web

{
  "appId": "14f1a266-629c-44aa-ad0f-9e09bed00f71",
  "applicationId": "myFirstWebAppsAppIn",
  "applicationType": "web",
  "creationDate": "2020-01-13T06:23:58.761173+00:00",
  "etag": "\"0500a71d-0000-0200-0000-5e1c0cfe0000\"",
  "flowType": "Bluefield",
  "hockeyAppId": null,
  "hockeyAppToken": null,
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myFirstWebApps-rg/providers/microsoft.insights/components/myFirstWebAppsAppIn",
  "instrumentationKey": "8bfd7511-d6ad-4ea8-9a10-d0db786ec415",
  "kind": "web",
  "location": "westeurope",
  "name": "myFirstWebAppsAppIn",
  "provisioningState": "Succeeded",
  "requestSource": "rest",
  "resourceGroup": "myFirstWebApps-rg",
  "samplingPercentage": null,
  "tags": {},
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "type": "microsoft.insights/components"
}
```

Add the Application Insights instrumentation key to your WebApp. Therefore, use the instrumentation key from the above output in the next command.

```shell
$ az webapp config appsettings set --settings APPINSIGHTS_INSTRUMENTATIONKEY=<YOUR_INSTRUMENTATION_KEY> -n myFirstWebAppDevCollege -g myFirstWebApps-rg
```

Now, we are all set to add a sample application.

## Create a sample application

We will use a .NET Core MVC application to demonstrate the deployment process to an Azure Web App. So first, let's create a demo application.

Create a local folder called _devcollege_ and open it in the comannd line. CD into that folder and execute:

```shell
$ dotnet new mvc -o myFirstCoreApp

The template "ASP.NET Core Web App (Model-View-Controller)" was created successfully.
This template contains technologies from parties other than Microsoft, see https://aka.ms/aspnetcore/3.0-third-party-notices for details.

Processing post-creation actions...
Running 'dotnet restore' on myFirstCoreApp/myFirstCoreApp.csproj...
  Restore completed in 60.34 ms for /Users/christiandennig/dev/myFirstCoreApp/myFirstCoreApp.csproj.

Restore succeeded.
```

### Visual Studio Code

After the wizard has finished, cd into the new folder _myFirstCoreApp_ and open it in VS Code:

```shell
$ code .
```

![vscode](./img/vscode_start.png "vscode")

Get familiar with the environment and have a look at the controller HomeController.

Set a breakpoint (F9) on method **public IActionResult Index()** in Controllers/HomeController.cs

Press F5 - if VS Code asks you about the environment, choose _.NET Core_

The project will now be built and after that, your browser will point to _https:/localhost:5001_.

#### Optional / Workaround

> Here is a workaround, if port _5001_ is blocked on your machine.

Open file _launch.json_ in the folder _.vscode_ and add the env variable **ASPNETCORE_URLS** with a value that works for you.

Example:

![vscode-launch](./img/vscode_launch.png "vscode-launch")

### Debug Tools

When the breakpoint gets hit, get familiar with the tools of the debugger.

![vscode-debug](./img/vscode_debug.png "vscode-debug")

Open _Views/Home/Index.cshtml_ and change the welcome text to "Welcome to the Azure Developer College".

Run it again locally and check, if the changes appear.

![browser-welcome](./img/browser_welcome.png "browser-welcome")

## Deploy the sample app to Azure

Now let's deploy the webapp to Azure.

If you haven't done so far, add the Azure App Service Extension (see: [Challenge 0 - Setup your system](./challenge-0.md))

Find your webapp in the extension and right-click --> Deploy to Web App...

> If you can't find your subscription, press **F1** and choose the Task _Azure: Sign In_.

![vscode-deploy](./img/vscode_deploy.png "vscode-deploy")

![vscode-deploying](./img/vscode_deploying.png "vscode-deploying")

After a few seconds the browser will show you your first web app running in Azure.

![browser-webapp](./img/browser_webappdevcollege.png "browser-webapp")

## Working with Deployment Slots

Open your web app in the portal and go to "Deployment Slots".

Create a new slot called "Staging" (choose clone settings from your production slot).

![portal-staging](./img/portal_staging.png "portal-staging")

When finished, go back to VS Code.

## Deploy sample application to Staging slot

Open _Views/Home/Index.cshtml_ again and change the welcome text to "Welcome to the Azure Developer College - this time with slots!".

Check that your local development environment works as expected.

![browser-staging](./img/browser_staging.png "browser-staging")

To deploy the application to the **Staging** slot, find your webapp in the **Azure AppService extension**, drill down to **Deployment Slots** and right-click --> Deploy to Slot...

Your current application will now be deployed to your "Staging" slot.

### Show Staging application

To see your staging slot in action, go to the slot in the portal and copy the URL in the overview blade.

![portal-slot-overview](./img/portal_slotoverview.png "portal-slot-overview")

Open your browser, navigate to the URL and check, if the headline contains the new text.

![browser-slot-website](./img/browser_slotwebsite.png "browser-slot-website")

> Also check the production slot (URL without "-staging").

### Swapping Slots

Now that everything works as expected, go back to "Deployment Slots" and click on "Swap" (selecting the staging slot as source).

With this command, we are swapping the current "poduction" slot with our "Staging" slot...which basically means that the Load Balancer in front of our Web App points to "Staging" and promotes it as the new "production" slot.

![portal-swap](./img/portal_swap.png "portal-swap")

Now check, that the production slot serves the new version of the website.

> **Optional**: Split traffic 50:50 to staging and production a see what happens when you reload your page in the browser pointing to the _production_ slot. What do you think, why does this happen??

## House Keeping

Remove the sample resource group.

```shell
$ az group delete -n myFirstWebApps-rg
```
