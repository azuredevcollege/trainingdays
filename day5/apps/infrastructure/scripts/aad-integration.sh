#!/bin/sh

API_APP_NAME=$1
API_APP_URI=$2
UI_APP_NAME=$3
UI_APP_REPLYURL=https://localhost

# create the API app
API_APP=$(az ad app create -o json --display-name $API_APP_NAME --identifier-uris $API_APP_URI --sign-in-audience AzureADMyOrg)
# wait a few seconds until app is created...
sleep 3
# get the app id
API_APP_ID=$(echo $API_APP | jq -r '.appId')
# # create a ServicePrincipal for the API
az ad sp create -o json --id $API_APP_ID

# create the UI App
UI_APP=$(az ad app create -o json --display-name $UI_APP_NAME --public-client-redirect-uris $UI_APP_REPLYURL --enable-access-token-issuance true --enable-id-token-issuance true)
UI_APP_ID=$(echo $UI_APP | jq -r '.appId')

echo "Making sure apps are available in AAD. Sleeping 30s..."
sleep 30s

echo "UI AppId for app $UI_APP_NAME: $UI_APP_ID"
echo "API AppId for app $API_APP_NAME: $API_APP_ID"
