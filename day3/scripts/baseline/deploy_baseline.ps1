if ($env:BASE_REGION_NAME -eq "") {
    echo "Region env name (BASE_REGION_NAME) is empty."
}
else {
    echo "Region env name is: " $env:BASE_REGION_NAME
}

if ($env:BASE_RG_COMMON_NAME -eq "") {
    echo "Resource Group COMMON env name (BASE_RG_COMMON_NAME) is empty."
}
else {
    echo "Resource Group COMMON env name is: " $env:BASE_RG_COMMON_NAME
}

if ($env:BASE_AI_NAME -eq "") {
    echo "AppInsights env name (BASE_AI_NAME) is empty."
}
else {
    echo "AppInsights env name is: " $env:BASE_AI_NAME
}

if ($env:BASE_STORAGEACCOUNT_FE_NAME -eq "") {
    echo "Storage Account Frontend env name (BASE_STORAGEACCOUNT_FE_NAME) is empty."
}
else {
    echo "Storage Account Frontend env name is: " $env:BASE_STORAGEACCOUNT_FE_NAME
}

if ($env:BASE_STORAGEACCOUNT_RES_NAME -eq "") {
    echo "Storage Account Resources env name (BASE_STORAGEACCOUNT_RES_NAME) is empty."
}
else {
    echo "Storage Account Resources env name is: " $env:BASE_STORAGEACCOUNT_RES_NAME
}

if ($env:BASE_API_WEBAPP_NAME -eq "") {
    echo "WebApp API env name (BASE_API_WEBAPP_NAME) is empty."
}
else {
    echo "WebApp API env name is: " $env:BASE_API_WEBAPP_NAME
}

if ($env:BASE_RES_WEBAPP_NAME -eq "") {
    echo "WebApp RES env name (BASE_RES_WEBAPP_NAME) is empty."
}
else {
    echo "WebApp RES env name is: " $env:BASE_RES_WEBAPP_NAME
}

if ($env:BASE_RES_FUNCAPP_NAME -eq "") {
    echo "FuncApp RES env name (BASE_RES_FUNCAPP_NAME) is empty."
}
else {
    echo "FuncApp RES env name is: " $env:BASE_RES_FUNCAPP_NAME
}

$rgCommon=(az group exists -n $env:BASE_RG_COMMON_NAME)
echo $rgCommon

if($rgCommon -eq "false") {
    echo "Creating COMMON resource group."
    az group create -l $env:BASE_REGION_NAME -n $env:BASE_RG_COMMON_NAME
} else {
    echo "Resource group COMMON exists."
}



echo "Deploying Common Resources."

az deployment group create -g $env:BASE_RG_COMMON_NAME --template-file ../../../day2/apps/infrastructure/templates/scm-common.json --parameters applicationInsightsName=$env:BASE_AI_NAME



echo "Deploying SCM API Resources."

az deployment group create -g $env:BASE_RG_COMMON_NAME --template-file ../../../day2/apps/infrastructure/templates/scm-api-dotnetcore.json --parameters applicationInsightsName=$env:BASE_AI_NAME sku=S1 use32bitworker=true alwaysOn=true webAppName=$env:BASE_API_WEBAPP_NAME

echo "Building and publishing SCM API Resources."

dotnet publish ../../../day2/apps/dotnetcore/Scm/Adc.Scm.Api/Adc.Scm.Api.csproj --configuration=Release -o ./publishContacts /property:GenerateFullPaths=true /property:PublishProfile=Release
Set-Location publishContacts
Compress-Archive -Path "./*" -DestinationPath "package.zip"
az webapp deployment source config-zip --resource-group $env:BASE_RG_COMMON_NAME --name $env:BASE_API_WEBAPP_NAME --src ./package.zip 
Set-Location ..



echo "Deploying SCM Res Resources."

az deployment group create -g $env:BASE_RG_COMMON_NAME --template-file ../../../day2/apps/infrastructure/templates/scm-resources-api-dotnetcore.json --parameters applicationInsightsName=$env:BASE_AI_NAME sku=S1 use32bitworker=true alwaysOn=true webAppName=$env:BASE_RES_WEBAPP_NAME storageAccountName=$env:BASE_STORAGEACCOUNT_RES_NAME functionAppName=$env:BASE_RES_FUNCAPP_NAME

echo "Building and publishing SCM Res Resources."

dotnet publish ../../../day2/apps/dotnetcore/Scm.Resources/Adc.Scm.Resources.Api/Adc.Scm.Resources.Api.csproj --configuration=Release -o ./publishRes /property:GenerateFullPaths=true /property:PublishProfile=Release
Set-Location publishRes 
Compress-Archive -Path "./*" -DestinationPath "package.zip"
az webapp deployment source config-zip --resource-group $env:BASE_RG_COMMON_NAME --name $env:BASE_RES_WEBAPP_NAME --src ./package.zip 
Set-Location ..

dotnet publish ../../../day2/apps/dotnetcore/Scm.Resources/Adc.Scm.Resources.ImageResizer/Adc.Scm.Resources.ImageResizer.csproj --configuration=Release -o ./publishFunc /property:GenerateFullPaths=true /property:PublishProfile=Release
Set-Location publishFunc 
Compress-Archive -Path "./*" -DestinationPath "package.zip" 
az webapp deployment source config-zip --resource-group $env:BASE_RG_COMMON_NAME --name $env:BASE_RES_FUNCAPP_NAME --src ./package.zip
Set-Location ..



echo "Deploying SCM Frontend Resources."

az deployment group create -g $env:BASE_RG_COMMON_NAME --template-file ../../../day2/apps/infrastructure/templates/scm-fe.json --parameters storageAccountName=$env:BASE_STORAGEACCOUNT_FE_NAME

echo "Activating Static Web site option in storage account."

az storage blob service-properties update --account-name $env:BASE_STORAGEACCOUNT_FE_NAME --static-website  --index-document index.html --404-document index.html

$aiKey=(az resource show -g $env:BASE_RG_COMMON_NAME -n $env:BASE_AI_NAME --resource-type "microsoft.insights/components" --query "properties.InstrumentationKey" -o tsv)

echo "Building frontend..."
Set-Location ../../../day2/apps/frontend/scmfe 
npm install 
npm run build 
Set-Location ../../../../day3/scripts/baseline

echo "var uisettings = { `"endpoint`": `"https://$env:BASE_API_WEBAPP_NAME.azurewebsites.net`", `"resourcesEndpoint`": `"https://$env:BASE_RES_WEBAPP_NAME.azurewebsites.net`", `"aiKey`": `"$aiKey`" };" > ../../../day2/apps/frontend/scmfe/dist/settings/settings.js
az storage blob upload-batch -d '$web' --account-name $env:BASE_STORAGEACCOUNT_FE_NAME -s ../../../day2/apps/frontend/scmfe/dist
