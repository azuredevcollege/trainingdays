# Challenge 0: Networking - Create a Virtual Network (IPv4) for your first VM

## Here is what you will learn 🎯

- Create your first Azure resources using the portal
- Learn how to navigate through the marketplace using search
- Experience the wizard / templates for creating Azure resources
- Use naming convention for Azure network artifacts
- See the unified deployment status page

## Logon to your [Azure subscription](https://portal.azure.com)  and create some resources

::: tip
📝 It sometimes helps to start the browser **in private | incognito mode** to avoid SSO with the wrong account landing in the wrong subscription especially if your are working on a domain joined device.  
:::

Click on the '+' symbol and use the search to find the corresponding Azure Resource Type, e.g. like:  

![CreateResourceGroup.png](./images/CreateResourceGroup.png)

Have a look at the naming conventions and suggestions:

- [Define your naming convention](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Recommended abbreviations for Azure resource types](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)

Define your naming convention and create the resources below accordingly:  

| Resource Type     |  Name                                                     | Values  |
|-----|-----|-----|
| Resource Group    |  `rg-<app or service name>-<subscription type>-<###>`     |  <ul><li>_Region_ : North Europe</li><li> _Tag_: e.g. creator : %yourName%<br> see: [tagging patterns](https://docs.microsoft.com/azure/cloud-adoption-framework/decision-guides/resource-tagging/?toc=/azure/azure-resource-manager/management/toc.json#resource-tagging-patterns)</li></ul> |
| Virtual Network   | `vnet-<subscription type>-<region>-<###>`                 | <ul><li>_Resource group_  : %see above%</li><li>_Region_  : North Europe</li><li>_AddressSpace_ : 10.1.0.0/16</li><li>_**One** subnet_: `snet-<subscription>-<region>-<###>` with _addressPrefix_: 10.1.0.0/24</li></ul> |
| Public IP address |  `pip-<vm name or app name>-<environment>-<region>-<###>` | <ul><li>IPv4</li><li>_SKU_ : Basic</li><li>_IP address assignment_: dynamic</li><li>_DNS name label_ : _%Enter unique value%_</li><li>_Resource group_  : %see above%</li><li>_Region_  : North Europe</li></ul> |

[🔼 Day 1](../README.md) | [Next challenge ▶](../challenge-01/README.md)
