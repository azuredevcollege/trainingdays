#!/bin/sh

API_APP_NAME=$1
API_APP_URI=$2
UI_APP_NAME=$3
UI_APP_REPLYURL=https://localhost

# create the API app
API_APP=$(az ad app create -o json --display-name $API_APP_NAME --identifier-uris $API_APP_URI --available-to-other-tenants false)
# wait a few seconds until app is created...
sleep 3
# get the app id
API_APP_ID=$(echo $API_APP | jq -r '.appId')
# disable default exposed scope
DEFAULT_SCOPE=$(az ad app show -o json --id $API_APP_ID | jq '.oauth2Permissions[0].isEnabled = false' | jq -r '.oauth2Permissions')
az ad app update -o json --id $API_APP_ID --set oauth2Permissions="$DEFAULT_SCOPE"
# set needed scopes from file 'oath2-permissions'
az ad app update -o json --id $API_APP_ID --set oauth2Permissions=@oauth2-permissions.json
# create a ServicePrincipal for the API
az ad sp create -o json --id $API_APP_ID

# create the UI App
UI_APP=$(az ad app create -o json --display-name $UI_APP_NAME --oauth2-allow-implicit-flow true)
UI_APP_ID=$(echo $UI_APP | jq -r '.appId')
UI_APP_OBJECTID=$(echo $UI_APP | jq -r '.objectId')

echo "Making sure apps are available in AAD. Sleeping 30s..."
sleep 30s

echo "Patching AAD Frontend app via URL:"
echo "https://graph.microsoft.com/v1.0/applications/$UI_APP_OBJECTID"
echo "Payload:"
echo "{\"spa\":{\"redirectUris\":[\"$UI_APP_REPLYURL\"]}}" | jq

az rest --method PATCH \
 --uri https://graph.microsoft.com/v1.0/applications/$UI_APP_OBJECTID \
 --headers "Content-Type=application/json" \
 --body "{\"spa\":{\"redirectUris\":[\"$UI_APP_REPLYURL\"]}}"

echo "UI AppId for app $UI_APP_NAME: $UI_APP_ID"
echo "API AppId for app $API_APP_NAME: $API_APP_ID"
