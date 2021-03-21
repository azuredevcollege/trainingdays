# Day 1 Azure Fundamentals & Infrastructure

## Welcome

This day is about getting a basic understanding of Azure and how to use its fundamental infrastructure services:

- Networking
- Virtual machines
- Storage accounts
- Azure Resource Manager Templates
- Azure Automation
  
## Challenges

- [Challenge 0: Networking - Create a Virtual Network (IPv4) for your first VM](./challenge-00/README.md)
- [Challenge 1: VM - Create a virtual machine using the Azure portal](./challenge-01/README.md)
- [Challenge 2: VM and Managed Disks - Attach a Data Disk to a VM, Extend and Retype it](./challenge-02/README.md)
- [Challenge 3: (optional): VM and AZure Backup - Save your VM state](./challenge-03/README.md)
- [Challenge 4:(optional): VM and Custom Script Extensions - Post deployment automation or  configure / setup / install something within an empty VM](./challenge-04/README.md)
- [Challenge 5: Cloud Shell - Coding Your Azure Resources](./challenge-05/README.md)
- [Challenge 6: Storage Account - Creating Data Storage for VMs and Applications](./challenge-06/README.md)
- [Challenge 7:ARM - Azure Resource Manager (ARM) Templates](./challenge-07/README.md)
- [Challenge 8: Networking - Enabling Hybrid Networking with a Site-2-Site VPN Connection** (Onprem to Azure) VPN Connection](./challenge-08/README.md)
- [Challenge 9: Networking - Connect Two Virtual Networks Using Azure VNET Peering](./challenge-09/README.md)
- [Challenge 10: Networking - Load balancing your WWW Server Farm](./challenge-10/README.md)
- [Challenge 11 (optional):  Networking - Distribute traffic accross global Azure regions using Traffic Manager](./challenge-11/README.md)
- [Challenge 12: Azure Automation - Send me yesterday's Azure cost](./challenge-12/README.md)

## Networking

> 🔑 Keywords: _VNET, peering, loadbalancer, VPN, Traffic Manager_

At first we create a _virtual network_ (VNET) in Azure. A VNET is a requirement for quite a few services in Azure e.g. virtual machines, firewalls, containers, web,etc. ([Challenge-0](./challenge-00/README.md)).  
A hybrid network connects your onpremise data center with Azure _Site-2-Site VPN_. This is a very common task - but quite a few steps to implement. Although infra work you should have done it once :-) ([Challenge-8](./challenge-08/README.md)).  
Traffic can flow within a single VNET. However if you need to connect two separate VNETs you need to do _network peering_ ([Challenge-9](./challenge-09/README.md)).  
_Azure loadbalancer_ is an easy way to distribute traffic between virtual machines. In [Challenge-10](./challenge-10/README.md) you configure it for a web server farm.  
Another service that helps to direct traffic flow & distribution weightings is Azure _Traffic Manager_. This is [Challenge-11](./challenge-11/README.md).

## Virtual Machines

> 🔑 Keywords: _create, disks, backup, post deployment automation_

Spinning up a _virtual machine_ in Azure using the portal is [Challenge-01](./challenge-01/README.md).  
You may need to _attach a data disk_ to a VM or resize it ([Challenge-02](./challenge-02/README.md))  
_Backup_ a VM is important, but fairly easy to do. Therefore we mark this as optional ([Challenge-03](./challenge-03/README.md)).  
_Post deployment automation_ offers a way on how to configure / install / run scripts within an VM after it has been created. Thus allowing a way to fully automate the setup of a web farm ([Challenge-4](./challenge-04/README.md)).

## Storage Accounts

> 🔑 Keywords: _container, SAS, access policy, file share_

_Storage Accounts_ is one of the first Azure services. They offer a way to store data on a massive / performant way at global scale with relatively cheap pricing. However, storing data in the cloud needs to be secured from anyone's access. One sub service of Azure storage accounts are Azure file shares, which can be attached to VMs ([Challenge-6](./challenge-06/README.md)).

## Automation & ARM (aka Azure Resource Manager)

> 🔑 Keywords: _Cloud Shell, Azure Resource Manager, provider, template, parameter, deployment, Azure Automation_  

Besides the portal, Azure offers other ways to connect to it. There are tools like _Azure CLI_ or _PowerShell_ to run CRUD-like commands against your Azure subscription. This offers a way to speed up deployments, reduce human error, build infrastructure as code, etc.. Azure _Cloud Shell_ is an easy already setup shell you can use right away ([Challenge-5](./challenge-05/README.md)).  

So-called _ARM templates_ offer a way to describe your Azure services in a json file. It can be used like an _'order-form'_ i.e. Azure will serve you with what you described within the ARM Template ([Challenge-7](./challenge-07/README.md)).

_Azure Automation_ is helpful do perform recurring tasks e.g. stopping & starting VMs to save costs based on a schedule. The idea is to let Azure execute scripts (that you provide) that can do things within your subscription. [Challenge-12](./challenge-12/README.md) is about gathering your Azure consumption / usage and send it to you via email as .csv for better cost prediction. Cool, isn't it?  
  
😎 **Enjoy your day!** 😎
