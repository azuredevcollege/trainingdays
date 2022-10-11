!/usr/bin/env bash

# Deploy common stuff...

PREFIX="azdc${RANDOM}"
echo "Prefix is $PREFIX."
EXECUTIONDIR=$PWD
if [ -z $BASE_REGION_NAME ]; then
    BASE_REGION_NAME="westeurope"
    echo "Region env name (BASE_REGION_NAME) is empty. Using $BASE_REGION_NAME."
else
    echo "Region env name is: $BASE_REGION_NAME"
fi

if [ -z $BASE_RG_COMMON_NAME ]; then
    BASE_RG_COMMON_NAME="$PREFIX-rg"
    echo "Resource Group COMMON env name (BASE_RG_COMMON_NAME) is empty. Using $BASE_RG_COMMON_NAME."
else
    echo "Resource Group COMMON env name is: $BASE_RG_COMMON_NAME"
fi

if [ -z $BASE_AI_NAME ]; then
    BASE_AI_NAME="${PREFIX}ai"
    echo "AppInsights env name (BASE_AI_NAME) is empty. Using $BASE_AI_NAME."
else
    echo "AppInsights env name is: $BASE_AI_NAME"
fi

if [ -z $BASE_STORAGEACCOUNT_FE_NAME ]; then
    BASE_STORAGEACCOUNT_FE_NAME="${PREFIX}fe"
    echo "Storage Account Frontend env name (BASE_STORAGEACCOUNT_FE_NAME) is empty. Using $BASE_STORAGEACCOUNT_FE_NAME."
else
    echo "Storage Account Frontend env name is: $BASE_STORAGEACCOUNT_FE_NAME"
fi

if [ -z $BASE_STORAGEACCOUNT_RES_NAME ]; then
    BASE_STORAGEACCOUNT_RES_NAME="${PREFIX}res"
    echo "Storage Account Resources env name (BASE_STORAGEACCOUNT_RES_NAME) is empty. Using $BASE_STORAGEACCOUNT_RES_NAME."
else
    echo "Storage Account Resources env name is: $BASE_STORAGEACCOUNT_RES_NAME"
fi

if [ -z $BASE_API_WEBAPP_NAME ]; then
    BASE_API_WEBAPP_NAME="${PREFIX}webapi"
    echo "WebApp API env name (BASE_API_WEBAPP_NAME) is empty. Using $BASE_API_WEBAPP_NAME."
else
    echo "WebApp API env name is: $BASE_API_WEBAPP_NAME"
fi

if [ -z $BASE_RES_WEBAPP_NAME ]; then
    BASE_RES_WEBAPP_NAME="${PREFIX}webres"
    echo "WebApp RES env name (BASE_RES_WEBAPP_NAME) is empty. Using $BASE_RES_WEBAPP_NAME."
else
    echo "WebApp RES env name is: $BASE_RES_WEBAPP_NAME"
fi

if [ -z $BASE_RES_FUNCAPP_NAME ]; then
    BASE_RES_FUNCAPP_NAME="${PREFIX}func"
    echo "FuncApp RES env name (BASE_RES_FUNCAPP_NAME) is empty. Using $BASE_RES_FUNCAPP_NAME."
else
    echo "FuncApp RES env name is: $BASE_RES_FUNCAPP_NAME"
fi

rgCommon=( `az group exists -o json -n $BASE_RG_COMMON_NAME` )

if [ "$rgCommon" = "false" ]; then
    echo "Creating COMMON resource group."
    az group create -l $BASE_REGION_NAME -n $BASE_RG_COMMON_NAME
else
    echo "Resource group COMMON exists."
fi

echo "Deploying Common Resources."

az deployment group create -g $BASE_RG_COMMON_NAME --template-file ../../../day2/apps/infrastructure/templates/scm-common.json --parameters applicationInsightsName=$BASE_AI_NAME
cd ${EXECUTIONDIR}
echo "Deploying SCM API Resources."

az deployment group create -g $BASE_RG_COMMON_NAME --template-file ../../../day2/apps/infrastructure/templates/scm-api-dotnetcore.json --parameters applicationInsightsName=$BASE_AI_NAME sku=S1 use32bitworker=true alwaysOn=true webAppName=$BASE_API_WEBAPP_NAME
cd ${EXECUTIONDIR}
echo "Building and publishing SCM API Resources."

dotnet publish ../../../day2/apps/dotnetcore/Scm/Adc.Scm.Api/Adc.Scm.Api.csproj --configuration=Release -o ./publishContacts /property:GenerateFullPaths=true /property:PublishProfile=Release
cd publishContacts && zip -r package.zip . && az webapp deployment source config-zip --resource-group $BASE_RG_COMMON_NAME --name $BASE_API_WEBAPP_NAME --src ./package.zip && cd ..
cd ${EXECUTIONDIR}
echo "Deploying SCM Res Resources."

az deployment group create -g $BASE_RG_COMMON_NAME --template-file ../../../day2/apps/infrastructure/templates/scm-resources-api-dotnetcore.json --parameters applicationInsightsName=$BASE_AI_NAME sku=S1 use32bitworker=true alwaysOn=true webAppName=$BASE_RES_WEBAPP_NAME storageAccountName=$BASE_STORAGEACCOUNT_RES_NAME functionAppName=$BASE_RES_FUNCAPP_NAME
cd ${EXECUTIONDIR}
echo "Building and publishing SCM Res Resources."

dotnet publish ../../../day2/apps/dotnetcore/Scm.Resources/Adc.Scm.Resources.Api/Adc.Scm.Resources.Api.csproj --configuration=Release -o ./publishRes /property:GenerateFullPaths=true /property:PublishProfile=Release
cd publishRes && zip -r package.zip . && az webapp deployment source config-zip --resource-group $BASE_RG_COMMON_NAME --name $BASE_RES_WEBAPP_NAME --src ./package.zip && cd ..

dotnet publish ../../../day2/apps/dotnetcore/Scm.Resources/Adc.Scm.Resources.ImageResizer/Adc.Scm.Resources.ImageResizer.csproj --configuration=Release -o ./publishFunc /property:GenerateFullPaths=true /property:PublishProfile=Release
cd publishFunc && zip -r package.zip . && az webapp deployment source config-zip --resource-group $BASE_RG_COMMON_NAME --name $BASE_RES_FUNCAPP_NAME --src ./package.zip && cd ..
cd ${EXECUTIONDIR}
echo "Deploying SCM Frontend Resources."

az deployment group create -g $BASE_RG_COMMON_NAME --template-file ../../../day2/apps/infrastructure/templates/scm-fe.json --parameters storageAccountName=$BASE_STORAGEACCOUNT_FE_NAME
cd ${EXECUTIONDIR}
echo "Activating Static Web site option in storage account."

az storage blob service-properties update --account-name $BASE_STORAGEACCOUNT_FE_NAME --static-website  --index-document index.html --404-document index.html

aiKey=( `az resource show -g $BASE_RG_COMMON_NAME -n $BASE_AI_NAME --resource-type "microsoft.insights/components" --query "properties.InstrumentationKey" -o tsv` )
cd ${EXECUTIONDIR}
echo "Building frontend..."
cd ../../../day2/apps/frontend/scmfe && npm install && npm install --production=false && npm install @vue/cli@4.5.15 -g --prefix ./cli-bin && npm install @vue/cli-service@4.5.15 -g --prefix ./cli-bin && ./cli-bin/bin/vue-cli-service build && cd ../../../../day3/scripts/baseline
cd ${EXECUTIONDIR}
echo "var uisettings = { \"endpoint\": \"https://$BASE_API_WEBAPP_NAME.azurewebsites.net\", \"resourcesEndpoint\": \"https://$BASE_RES_WEBAPP_NAME.azurewebsites.net\", \"aiKey\": \"$aiKey\" };" > ../../../day2/apps/frontend/scmfe/dist/settings/settings.js
az storage blob upload-batch -d '$web' --account-name $BASE_STORAGEACCOUNT_FE_NAME -s ../../../day2/apps/frontend/scmfe/dist

echo "Cleaning up publish folders..."
rm -rf publish*
cd ${EXECUTIONDIR}
echo "Done. Resources have been deployed in resource group $BASE_RG_COMMON_NAME."
echo ""
echo "Website can be accessed via:"
echo ""
az storage account show -n $BASE_STORAGEACCOUNT_FE_NAME --query "primaryEndpoints.web" --output tsv
