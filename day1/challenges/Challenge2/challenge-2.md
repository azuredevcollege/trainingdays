# Challenge 2: ARM: Create a VM and other Azure Resources using an ARM Template 
[back](../../README.md)  

In this module you will **not learn** how to build an ARM template yourself. We'll do this at a later point in time.  
**What you need** to know / understand is that an **ARM template is a txt file** (in a **machine readable json format**) that **describes** which **azure resources** you want.  
ARM templates can be used as a **building plan** for fast azure resource creation.  
ARM _'powered'_ deployments are:  
- Less error prone - than clicking
- Few typing required
- No reading through (inaccurate) documentation with screenshots and try to replay it manually.

## Here is what you will learn ##

- Creating some azure resources (VNET, Subnets, VM,...) using an ARM template and the portal.

## Deploy an ARM template using the portal

0. _optional_ **Cleanup** all resources that have been created in this workshop e.g. by deleting the resource groups.  

1. Login to your azure subscription **and search the marketplace for 'Template Deployment'**    
![Azure Template Deployment](TemplateDeployment.PNG)
  
2. Create -> select '**Build your own template in the editor**'
3. Copy the RAW view of [this ARM template](ARMOne.json) and paste it into the editor **clear first** window.  
->Save  
4. **Create a resource group and set the location**  

| Resource Type |  Name | Values  |
|---|---|---|
| Resource Group  |  rg-contosomortgage-www |  _location_ : North Europe |

![Template Deployment Enter Parameters](TemplateDeployment2.PNG)  
and hit **Purchase** to trigger the deployment.

5. **Once finished your deployment should look like**:
[Azure Portal] -> Resource Group -> 'rg-contosomortgage-www' -> Deployments -> 'Microsoft.Template' -> 'Deployment details'

![Template Deployment Results](TemplateDeployment3.PNG)  

**Is this deployment fast? Redeployable? Replayable in another subscription?**

[back](../../README.md) 