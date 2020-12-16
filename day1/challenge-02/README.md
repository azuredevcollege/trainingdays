# Challenge 2: VM - Managed Disks: Attach a Data Disk to a VM - Extend and Retype it.
## Here is what you will learn ##
- Create a data disk and attach it to a vm

```
[Azure Portal] -> Virtual machines -> e.g. 'vmfirst001' -> Data disks -> "+ Create and attach a new disk"
```  
| Name | Value |
|---|---|
| LUN (aka _logical unit number_)  |  e.g. **0** |
| Disk name  |  e.g **vmfirst001-disk-001** |   
| Account type | **Standard SSD** |
| Size  |  **128GiB (E10)** | 
| Host caching  |  **Read/write** | 

Don't forget to **press the _save_ button!**

## Logon to your windows vm and partition the disk ##
```
[Azure Portal] -> Virtual machines -> e.g. 'vmfirst001' -> Connect -> RDP -> Download RDP File -> open...
```  
Once logged into the vm - execute **_diskmgmt.msc_** to open the **Disk Manager**. Your attached data disk will show up 'uninitialized'.  
**Initialize** it:  
![Disk Manager](./datadisk0.png)  
  
**Partition and format** it:  
![Disk Manager extended disk](./datadisk1.png)

## Extend your disk ##
To **modify an existing disk it must be first 'detached' first** from the vm
```
[Azure Portal] -> Virtual machines -> e.g. 'vmfirst001' -> Disks
```
**Detach !**  
  
![VM disk detach](./vmDiskDetach.png)  
And don't forget the **SAVE** button!

**Find your disk in the resource group and change it's configuration**
```
[Azure Portal] -> Resource Groups -> rg-firstvm-test-001 -> vmfirst001-disk-001 -> Size + performance
```
**The new disk should**:
- **support 99.9% availabilty**
- have 256GiB disksize and **support 1100 IOPS disk**  

>**Reference**:
>- [What disk types are available in Azure?](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/disks-types)
  

**Attach disk back to vm.**  
Once done it'll show up in the vm like:  
![VM with extended disk](./datadisk2.png)

>**Note**: **Attaching** data disks can be **done with a runnning vm**.

> **Questions**:  
> - How much is a E10 / month? (fix price, variable costs, region differences)
> - Can a disk be resized without losing its data? 
> - Can I easily downsize a disk? 
  
> **Cleanup - Note**:  
> **If you do not want to do the [optional] labs** 'vm backup' or 'post deployment automation with CSE' t**hen you can delete this resource group** and all its containing artefacts. 