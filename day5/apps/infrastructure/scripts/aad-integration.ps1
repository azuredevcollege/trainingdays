param(
    [Parameter(Mandatory = $true)]
    [string]$ApiAppName,
    [Parameter(Mandatory = $true)]
    [string]$ApiAppUri,
    [Parameter(Mandatory = $true)]
    [string]$UiAppName,
    [Parameter(Mandatory = $true)]
    [string]$UiAppReplyUrl)
    
    # read the exposed permission first
    $exposedPermissionsFromJson = Get-Content -Raw -Path ./oauth2-permissions.json | ConvertFrom-Json

    $exposedPermissions = New-Object System.Collections.Generic.List[Microsoft.Open.AzureAD.Model.OAuth2Permission]

    $exposedPermissionsFromJson |
        ForEach-Object -Process {
            $permission = New-Object Microsoft.Open.AzureAD.Model.OAuth2Permission
            $permission.Id = [System.Guid]::Parse($_.id)
            $permission.IsEnabled = $true
            $permission.Type = $_.type
            $permission.AdminConsentDisplayName = $_.adminConsentDisplayName
            $permission.AdminConsentDescription = $_.adminConsentDescription
            $permission.UserConsentDescription = $_.userConsentDescription
            $permission.UserConsentDisplayName = $_.userConsentDisplayName
            $permission.Value = $_.value

            $exposedPermissions.Add($permission)
        }
    # create the ApiApp
    $apiApp = New-AzureADApplication -DisplayName $ApiAppName -IdentifierUris $ApiAppUri -AvailableToOtherTenants $false 
    # remove the default created OAuth2Permission
    $apiApp = Get-AzureADApplication -Filter "AppId eq '$($apiApp.AppId)'"
    $apiApp.Oauth2Permissions[0].IsEnabled = $false
    Set-AzureADApplication -ObjectId $apiApp.ObjectId -Oauth2Permissions $apiApp.Oauth2Permissions
    # set the OAuth2Permissions
    Set-AzureADApplication -ObjectId $apiApp.ObjectId -Oauth2Permissions $exposedPermissions
    # create a ServicePrincipal
    New-AzureADServicePrincipal -AppId $apiApp.AppId

    # create the UI app
    $uiApp = New-AzureADApplication -DisplayName $UiAppName -AvailableToOtherTenants $false -ReplyUrls $UiAppReplyUrl -Oauth2AllowImplicitFlow $true

    Write-Host "ApiAppId: $($apiApp.AppId)"
    Write-Host "UiAppId: $($uiApp.AppId)"
