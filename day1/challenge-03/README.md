# Challenge 3 (optional): VM and Azure Backup - Save your VM state

## Here is what you will learn 🎯

- How to backup an Azure VM using the Azure backup service.
- Create a backup vault
- Recover a file

## Table Of Contents

1. [Starting point](#starting-point)
2. [Create a Backup Vault](#create-a-backup-vault)
3. [Trigger a Manual VM Backup](#trigger-a-manual-vm-backup)
4. [Do a VM Recovery (optional)](#do-a-vm-recovery-optional)
5. [Do a File Recovery (optional)](#do-a-file-recovery-optional)

## Starting point  

In case you need a VM to backup - **Click** on the
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazuredevcollege%2Ftrainingdays%2Fmaster%2Fday1%2Fchallenge-03%2Fchallengestart%2Fchallengestart.json"><img src="./challengestart/deploytoazure.png"/></a>
button.

## Create a Backup Vault

```
[Azure Portal] 
-> Resource Groups 
-> 'rg-contosomortgage-www' 
-> 'vmweb01'
-> Operations -> Backup

###

Recovery Services vault 
-> 'Create new' 
-> 'vault...'

###

Resource Group 
-> 'Create new' 
-> 'rg-contosomortgage-backups'

###

Choose backup policy 
-> '(new) DailyPolicy' 
-> Enable Backup
```  

::: tip
📝 You might want to pack all of your VM backups **in a separate Resource Group** as backups of VMs might live longer than the actual VM.

![EnableBackup](./images/enableBackup1.png)
:::

## Trigger a Manual VM Backup

- Navigate to your VM in the Azure portal -> Operations -> Backup
  🔎 **Observation** The view has changed after creating the vault.  
- Trigger the backup manually

  ![Trigger the backup manually](./images/enableBackupTriggerManually.png)  
  
- Press `View all jobs` to get a status of the backup. It'll take some time for the backup to finish.

  > ❔ **Questions**:
  >
  > - How many copies of backup data does Azure do ('redundancy') by default?
  > - Do offline VMs also get backup'ed?
  > - What is 'Soft Delete'?
  > - Which 'Azure' workloads can be backed up?
  > - Does Azure Backup support 'on premise' backups?

  ::: tip
  📝 Try to answer some questions through navigating to your backup vault properties  

  ```
  [Azure Portal] 
  -> Resource Groups 
  -> 'rg-contosomortgage-backups' 
  -> 'vault...' 
  -> Properties
  ```

  :::

## Do a VM Recovery (optional)

```
[Azure Portal]
-> Virtual Machines 
-> vmadds01 
-> Operations 
-> Backup 
-> Restore VM
```

> ❔ **Question** What is needed for a VM recovery?  

## Do a File Recovery (optional)

File recovery enables you to recover individual files selected from a backup at a given point in time.  
The backup is _mounted_ as drive to your local machine via the internet.  

```
[Azure Portal] 
-> Virtual Machines 
-> vmadds01 
-> Operations 
-> Backup 
-> File Recovery  
```  

![File Restore](./images/enableBackupFileRestore.png)

[◀ Previous challenge](../challenge-02/README.md) | [🔼 Day 1](../README.md) | [Next challenge ▶](../challenge-04/README.md)
