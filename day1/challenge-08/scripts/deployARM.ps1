$RGs = @{
    'rg-wwwlb-NE' = 'North Europe'
    'rg-wwwlb-WE' = 'West Europe'
    'rg-wwwlb' = 'North Europe'
}
$RGs.GetEnumerator()| % {New-AzResourceGroup -Name $_.Name -Location $_.Value}

New-AzResourceGroup -Name 'rg-wwwlb-NE' -Location 'North Europe'
New-AzResourceGroup -Name 'rg-wwwlb-WE' -Location 'West Europe'
New-AzResourceGroup -Name 'rg-wwwlb' -Location 'North Europe'

$TemplateParameters = @{
    "adminUser" = [string]'demouser';
    "adminPassword" = [System.Security.SecureString](Read-Host -Prompt "adminUser password please" -AsSecureString);
    "vmNames" = [array]@('vmblue','vmred');
    "vmSize" = [string]'Standard_F2s_v2' # or 'Standard_B2s'
    "DiskSku" = [string]'StandardSSD_LRS'
}
New-AzResourceGroupDeployment -Name 'NE' -TemplateFile "/home/bernhard/challengestart.json" -ResourceGroupName 'rg-wwwlb-NE' -TemplateParameterObject $TemplateParameters -AsJob

$TemplateParameters.vmNames = @('vmyellow','vmgreen')
New-AzResourceGroupDeployment -Name 'WE' -TemplateFile "/home/bernhard/challengestart.json" -ResourceGroupName 'rg-wwwlb-WE' -TemplateParameterObject $TemplateParameters -AsJob

#cleanup
Remove-AzResourceGroup -Name 'rg-wwwlb-NE' -force -AsJob
Remove-AzResourceGroup -Name 'rg-wwwlb-WE' -force -AsJob
Remove-AzResourceGroup -Name 'rg-wwwlb' -force -AsJob
