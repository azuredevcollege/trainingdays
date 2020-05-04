# Challenge 3: VM - Azure Backup: Save your VM state
[back](../../README.md)  

## Here is what you will learn ##

- How to backup an azure vm using the azure backup service.
- Create a backup vault
- Recover a file


## Create a Backup Vault ##
```
[Azure Portal] -> Resource Groups -> 'rg-contosomortgage-www' -> 'vmweb01'
  -> Operations -> Backup

Recovery Services vault -> 'Create new' -> 'vault...'
Resource Group -> 'Create new' -> 'rg-contosomortgage-backups'
Choose backup policy -> '(new) DailyPolicy'
  ->Enable Backup
```  
**Note:** You might want to **pack all of your vm backups in a separate Resource Group** as backups of vms might live longer than the actual vm.  
![EnableBackup](enableBackup1.PNG)

## Trigger a manual vm backup ##

Navigate to your vm in the azure portal -> Operations -> Backup  
Note that **the view has changed** after creating the vault.  
**Trigger the backup manually**.  
![Trigger the backup manually](enableBackupTriggerManually.PNG)  
  
**Press** _'View all jobs'_ to get a status of the backup.  
It'll take some time for the backup to finish.

## Answer Following Questions ##
  
1. How many copys of backup data does Azure do ('redundancy') by default?
2. Do offline VMs also get backup'ed?
3. What is 'Soft Delete' ?
4. Which 'Azure' workloads can be backed up?
5. Does Azure Backup support 'onpremise' backups?

**Hint:** Try to answer some questions through navigating to your backup vault properties  
```
[Azure Portal] -> Resource Groups -> 'rg-contosomortgage-backups' -> 'vault...' -> Properties
```

## [optional]: Do a VM Recovery ##
Azure Portal -> Virtual Machines -> vmadds01 -> Operations -> Backup -> Restore VM

What is **needed** for a VM recovery?  

## [optional]: Do a File Recovery ##
File recovery enables you to recover individual files selected from a backup at a given point in time.  
The backup is _'mounted'_ as drive to your local machine via the internet.  

Azure Portal -> Virtual Machines -> vmadds01 -> Operations -> Backup -> File Recovery  
  
![File Restore](enableBackupFileRestore.PNG)


[back](../../README.md) 