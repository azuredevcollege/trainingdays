# Day 1 Azure Fundamentals & Infrastructure
>**Welcome!**  
This day is about getting a **basic understanding of Azure and how to use its fundamental infrastructure services**:
> - **networking**  
> - **virtual machines** 
> - **storage accounts** 
> - **ARM** 
  
## Challenges ##
- [Challenge 0: **Networking**: **Create a Virtual Network** (IPv4) for your first VM.](./challenge-00/README.md)
- [Challenge 1: **VM**: **Create a virtual machine** using the Azure portal](./challenge-01/README.md)
- [Challenge 2: **VM** - Managed Disks: **Attach a Data Disk to a VM** - Extend and Retype it.](./challenge-02/README.md)
- [Challenge 3 **(optional): VM**- Azure Backup: Save your VM state](./challenge-03/README.md)
- [Challenge 4 **(optional): VM** - Custom Script Extensions: Post deployment automation - or - configure / setup / install something within an empty vm](./challenge-04/README.md)
- [Challenge 5 **Cloud Shell**: Using PowerShell for Azure Administration and Automation](./challenge-05/README.md)
- [Challenge 6: **Storage Account**: **Creating Data Storage for VMs and Applications**](./challenge-06/README.md)
- [Challenge 7: **ARM**: Azure Resource Manager (ARM) Templates](./challenge-07/README.md)
- [Challenge 8: **Networking**: **Enabling Hybrid Networking with a Site-2-Site VPN Connection** (Onprem to Azure) VPN Connection](./challenge-08/README.md)
- [Challenge 9: Networking: Connect Two Virtual Networks Using Azure VNET Peering](./challenge-09/README.md)
- [Challenge 10: Networking: Loadbalancing your WWW Server Farm](./challenge-10/README.md)
- [Challenge 11 (optional): Networking: Distribute traffic accross global Azure regions using Traffic Manager](./challenge-11/README.md)



## Networking ##
_(VNET, peering, loadbalancer, VPN, Traffic Manager)_  
- First we create a virtual network (VNET) in Azure.  
There are quire a few services that can be deployed into a virtual network (e.g. virtual machines, firewalls, containers, web,...). We will create a simple vnet using a private IP range ([RFC 1918](https://www.rfc-editor.org/rfc/rfc1918))  
- Connect 2 VNETs  
Traffic can flow within a single vnet - however if you need to connect 2 separate vnets you need to do network peering.
- Build a hybrid network (Site-2-Site VPN)  
- Configure a loadbalancer 
- Region based traffic distribution



## Virtual Machines ##
(create, disks, backup, post deployment automation )
In challenge 1 we create a 

## Storage Accounts ##
(container, SAS, access policy, file share)

## ARM (aka Azure Resource Manager) ##
(Azure Resource Manager, provider, template, parameter, deployment)
