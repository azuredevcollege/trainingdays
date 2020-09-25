# Challenge 1: Cloud Shell: Using PowerShell for Azure Administration and Automation

[back](../../README.md)

## Here is what you will learn ##

- Use the 'Cloud Shell' as _'launch point'_ for PowerShell to automate Azure resource creation and configuration.
- Learn it's benefits (vs. using PowerShell on your PC)
- Learn to know which PowerShell modules are used.
  
## Benefits of the Azure Cloud Shell ##
The Azure **Cloud Shell is a shell | console hosted in your browser window**. Ready to **execute commands to create, delete, modify Azure resources in your subscription**.  
While it is also possible to use PowerShell on your local PC to administer Azure. Using the Cloud Shell brings some advantages compared to using your PC as 'launch point'.  

Using the **Cloud Shell saves you time** as...:  
- **no need to explicitly code the azure logon within the script** - you are already authenticated to Azure via the browser ;-)
- **nothing needs to be installed on your PC** ([no "which version of PowerShell? What modules?](https://docs.microsoft.com/en-us/powershell/azure))"

## Create an Azure Cloud Shell (if you don't have one.)
```
[Azure Portal] -> Click the 'Cloud Shell' symbol close to your login details on the right upper corner.
```  
![Cloud Shell](CloudShell.png))  
The **'Cloud Shell' is an in-browser-accessible shell for managing Azure resources**. It already has the required SDKs and tools installed to interact with Azure. You can use either Bash or PowerShell.  
When being asked **choose PowerShell this time**.  
**The first time you use the 'Cloud Shell' you will be asked to setup a storage account** e.g. to store files you have uploaded persistently. [See](https://docs.microsoft.com/en-us/azure/cloud-shell/persisting-shell-storage)  

```
[Azure Portal] -> Click 'Show advanced settings'
```  
![Cloud Shell Storage Account Setup](CloudShell1.png)  

| Name | Value |
|---|---|
| Subscription  |  _your subscription_ |
| Cloud Shell Region  |  e.g. **North Europe** |   
| Resource Group  |  e.g. **rg-cloudshell** |   
| Storage Account  |  **_some unique value_** |   
| File Share  |  **cloudshell**|   

```
[Azure Portal] -> Create storage
```  
Once successful your shell should appear at the bottom of the page:  
![Cloud Shell in the Azure portal](CloudShell2.png)

## Playing with the Cloud Shell ##
**Execute your first commands**. Using 'PowerShell' as environment ('bash' is also possible) you can either call:  
**Azure CLI code** snippets, e.g.:
```
az account show
```  
or launch **Azure PowerShell snippets**, like:
```PowerShell
Get-AzSubscription
```
choose whatever you prefer - most Azure documentation available shows both ways - sometimes one is shorter than the other.  
**Note that Azure seems to use PowerShell Core on a Linux OS for its Cloud Shell: Execute...**
```PowerShell
$psversiontable
```  
should return something like:  
![PowerShell Version output](CloudShell3.png)  


Let's query e.g. the available VM sizes in a specific region:
```PowerShell
Get-AzVMSize -Location 'west europe'
```
Output should be something like:
```
Name                   NumberOfCores MemoryInMB MaxDataDiskCount OSDiskSizeInMB ResourceDiskSizeInMB
----                   ------------- ---------- ---------------- -------------- --------------------
Standard_A0                        1        768                1        1047552                20480
Standard_A1                        1       1792                2        1047552                71680
Standard_A2                        2       3584                4        1047552               138240
Standard_A3                        4       7168                8        1047552               291840
.
.
.

```

## PowerShell Az Modules for Azure ##
The so-called PowerShell _cmdlets_ (e.g. 'Get-Date', 'Get-AzVMSize',...) are grouped into modules.  
There are **specific modules for Azure administration: the '_Az modules_'**
Execute:
```PowerShell
Get-Module az* -ListAvailable
```
**to list the pre-installed Az modules**:  
```
Directory: C:\Program Files\WindowsPowerShell\Modules

    Directory: /usr/local/share/powershell/Modules

ModuleType Version    PreRelease Name                                PSEdition ExportedCommands
---------- -------    ---------- ----                                --------- ----------------
Script     4.6.1                 Az                                  Core,Desk
Script     1.9.3                 Az.Accounts                         Core,Desk {Disable-AzDataCollection, Disable-AzContextAutosave, Enable-AzDataCollection, Enable-AzCon…
Script     1.1.1                 Az.Advisor                          Core,Desk {Get-AzAdvisorRecommendation, Enable-AzAdvisorRecommendation, Disable-AzAdvisorRecommendati…
Script     1.2.0                 Az.Aks                              Core,Desk {Get-AzAksCluster, New-AzAksCluster, Remove-AzAksCluster, Import-AzAksCredential…}
Script     1.1.4                 Az.AnalysisServices                 Core,Desk {Resume-AzAnalysisServicesServer, Suspend-AzAnalysisServicesServer, Get-AzAnalysisServicesS…
Script     2.1.0                 Az.ApiManagement                    Core,Desk {Add-AzApiManagementApiToGateway, Add-AzApiManagementApiToProduct, Add-AzApiManagementProdu…
Script     1.1.0                 Az.ApplicationInsights              Core,Desk {Get-AzApplicationInsights, New-AzApplicationInsights, Remove-AzApplicationInsights, Update…
Script     1.4.0                 Az.Automation                       Core,Desk {Get-AzAutomationHybridWorkerGroup, Remove-AzAutomationHybridWorkerGroup, Get-AzAutomationJ…
Script     3.1.0                 Az.Batch                            Core,Desk {Remove-AzBatchAccount, Get-AzBatchAccount, Get-AzBatchAccountKey, New-AzBatchAccount…}
Script     1.0.3                 Az.Billing                          Core,Desk {Get-AzBillingInvoice, Get-AzBillingPeriod, Get-AzEnrollmentAccount, Get-AzConsumptionBudge…
Script     1.4.3                 Az.Cdn                              Core,Desk {Get-AzCdnProfile, Get-AzCdnProfileSsoUrl, New-AzCdnProfile, Remove-AzCdnProfile…}
.
.
.
```
**To find out which module hosts which cmdlet** (e.g. Get-AzVMSize) **type** something like:
```PowerShell
get-command *vmsize*
```
Result similar to:  
```
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           Get-AzureRmVMSize
Cmdlet          Get-AzDtlAllowedVMSizesPolicy                      1.0.2      Az.DevTestLabs
Cmdlet          Get-AzVMSize                                       4.3.1      Az.Compute
Cmdlet          Set-AzDtlAllowedVMSizesPolicy                      1.0.2      Az.DevTestLabs
```  

To find out all commands hosted in the Az.Compute module type:
```PowerShell
Get-Command -Module Az.Compute
```
delivers e.g.:
```
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
.
.
.
Cmdlet          New-AzSnapshotUpdateConfig                         4.3.1      Az.Compute
Cmdlet          New-AzVM                                           4.3.1      Az.Compute
Cmdlet          New-AzVMConfig                                     4.3.1      Az.Compute
Cmdlet          New-AzVMDataDisk                                   4.3.1      Az.Compute
Cmdlet          New-AzVMSqlServerAutoBackupConfig                  4.3.1      Az.Compute
Cmdlet          New-AzVMSqlServerAutoPatchingConfig                4.3.1      Az.Compute
Cmdlet          New-AzVMSqlServerKeyVaultCredentialConfig          4.3.1      Az.Compute
.
.
.
```
## Create a VM with PowerShell ...
Now **let's create a VM using PowerShell**.  
**_New-AzVM_** seems to be a good candidate but **you may need some help** with the parameters.  
**Try _help New-AzVM_** **or execute**:  
```PowerShell
help New-AzVM -online
```
this **should open a new browser tab with online help for New-AzVM**. Examine the explanation and look at the code samples.

Try **creating a simple VM by executing**:  
```PowerShell
$VMName = 'MyVM'    # variable for easy reuse
New-AzVM -Name $VMName -Credential (Get-Credential) -Location 'North Europe' -Size 'Standard_A0'
```
**Enter a user name** (not 'admin' nor 'administrator') **and a complex password** when asked.
![progress in azure cloud shell](newvm.png) 
After a successful run you should have a VM in your subscription:  
 ![MyVM in Azure Portal](newvm2.png)  
  
**Cleanup** e.g. **by deleting** the resource group with the vm **using the portal or via executing**:
```PowerShell
Remove-AzResourceGroup $VMName -Force -AsJob   # -AsJob will execute this operation in the background 
```
> **In case of a error** try restarting the cloud shell as it times out.  
  

[back](../../README.md)