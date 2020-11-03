#!/bin/sh

API_APP_NAME=$1
API_APP_URI=$2
UI_APP_NAME=$3
UI_APP_REPLYURL=$4

# create the API app
API_APP=$(az ad app create --display-name $API_APP_NAME --identifier-uris $API_APP_URI --available-to-other-tenants false)
# wait a few seconds until app is created...
sleep 3
# get the app id
API_APP_ID=$(echo $API_APP | jq -r '.appId')
# disable default exposed scope
DEFAULT_SCOPE=$(az ad app show --id $API_APP_ID | jq '.oauth2Permissions[0].isEnabled = false' | jq -r '.oauth2Permissions')
az ad app update --id $API_APP_ID --set oauth2Permissions="$DEFAULT_SCOPE"
# set needed scopes from file 'oath2-permissions'
az ad app update --id $API_APP_ID --set oauth2Permissions=@oauth2-permissions.json
# create a ServicePrincipal for the API
az ad sp create --id $API_APP_ID

# create the UI App
UI_APP=$(az ad app create --display-name $UI_APP_NAME --oauth2-allow-implicit-flow true --reply-urls $UI_APP_REPLYURL)
UI_APP_ID=$(echo $UI_APP | jq -r '.appId')

echo "UI AppId: $UI_APP_ID"
echo "API AppId: $API_APP_ID"
