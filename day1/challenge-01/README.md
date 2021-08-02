# Challenge 1: Virtual Machines - Create a virtual machine using the Azure portal

## Here is what you will learn 🎯

- Create a VM using the Azure portal
- See what belongs to a VM
- use naming convention for VM Azure artifacts

## Create a virtual machine

- Search for virtual machines in the portal and hit the '+' symbol to add a VM:

   ![vmservices.png](./images/vmservices.png)
  
- Create the VM according to the table:  

| Name | Values  |
|---|---|
| _Resource group_ | %use from previous lab% |
| _Virtual machine name_ | `vm<policy name or app name><###>`|
| _Region_ | North Europe |
| _Availability options_ | Availabilty set  |
| _Availability set_ | <ul><li>Name: `avail-<app or service name>-<subscription type>-<region>-<###>`</li><li>Fault domains: 2</li><li>Update domains: 5</li></ul> |
| _Image_ | Windows Server 2019 Datacenter - Gen1 |
| _Size_ | %Choose a size% |
| _Username_ | **not** 'Admin' **nor** 'Administrator' **nor** 'root' |
| _Password_ | %complex enough% |
| _OS disk type_ | Standard SSD |
| _Virtual network_ | e.g. the vnet from previous challenge-00 |
| _Public IP_ | _e.g. the public IP from previous challenge-00 |
| _Boot diagnostics_ | Disable  |
| _Tag_ | e.g. creator : %yourName% |  
  
::: tip
📝 Helpful Reference: Azure naming conventions:

- [Define your naming convention](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)  
- [Recommended abbreviations for Azure resource types](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)

:::

## Result

You should find the following Azure artifacts in your resource group after this challenge:
  
![azure artifacts in resource group after challenge](./images/result.png)

[◀ Previous challenge](../challenge-00/README.md) | [🔼 Day 1](../README.md) | [Next challenge ▶](../challenge-02/README.md)
