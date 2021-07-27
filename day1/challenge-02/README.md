# Challenge 2: VM and Managed Disks - Attach a Data Disk to a VM, Extend and Retype it

## Here is what you will learn 🎯

- Create a data disk and attach it to a virtual machine

## Table Of Contents

1. [Create and attach a new disk](#create-and-attach-a-new-disk)
2. [Logon to your windows VM and partition the disk](#logon-to-your-windows-vm-and-partition-the-disk)
3. [Extend your disk](#extend-your-disk)
4. [Cleanup](#cleanup)

## Create and attach a new disk

```
[Azure Portal] 
-> Virtual machines 
-> e.g. 'vmfirst001' 
-> Data disks 
-> "+ Create and attach a new disk"
```  

| Name | Value |
|---|---|
| _LUN (aka logical unit number)_  |  e.g. 0 |
| _Disk name_  |  e.g. vmfirst001-disk-001|
| _Account type_ | Standard SSD |
| _Size_ |  128GiB (E10) |
| _Host caching_ |  Read/write |

And don't forget the **SAVE** button!

## Logon to your windows VM and partition the disk

```
[Azure Portal] 
-> Virtual machines e.g. 'vmfirst001' 
-> Connect 
-> RDP 
-> Download RDP File 
-> open...
```  

- Once logged into the VM - execute `diskmgmt.msc` to open the Disk Manager. Your attached data disk will show up 'uninitialized'.  
- Initialize:

   ![Disk Manager](./images/datadisk0.png)  
- Partition and format it:

  ![Disk Manager extended disk](./images/datadisk1.png)

## Extend your disk

- To modify an existing disk it must be **'detached'** first from the VM:

   ```
   [Azure Portal] 
   -> Virtual machines e.g. 'vmfirst001'
   -> Disks
   ```

- Detach it  
  
   ![VM disk detach](./images/vmDiskDetach.png)  

And don't forget the **SAVE** button!

- Find your disk in the resource group and change it's configuration

   ```
   [Azure Portal] 
   -> Resource Groups 
   -> rg-firstvm-test-001 
   -> vmfirst001-disk-001 
   -> Size + performance
   ```

- The new disk should:
  - support **99.9% availabilty**
  - have 256GiB disk size and support **1100 IOPS disk**  

   ::: tip
   📝 Reference: [What disk types are available in Azure?](https://docs.microsoft.com/azure/virtual-machines/windows/disks-types)
   :::

- Attach disk back to VM. Once done it'll show up in the VMs like:

   ![VM with extended disk](./images/datadisk2.png)

   :::tip
   📝 Attaching data disks can be done with a running VM.
   :::

> ❔ **Questions**:
>  
> - How much is a E10 / month? (fix price, variable costs, region differences)
> - Can a disk be resized without losing its data?
> - Can I easily downsize a disk?
  
## Cleanup

Delete the resource group. This will also delete its containing artifacts.

```
[Azure Portal] 
-> Resource Groups 
-> rg-firstvm-test-001 
-> 'Delete resource group'
```

[◀ Previous challenge](../challenge-01/README.md) | [🔼 Day 1](../README.md) | [Next challenge ▶](../challenge-03/README.md)
