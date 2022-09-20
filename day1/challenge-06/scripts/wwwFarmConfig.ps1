configuration wwwFarmConfig
{
    param
    (
        [Parameter(mandatory = $true)]
        [string]$webZipURI
    )
    # One can evaluate expressions to get the node list
    # E.g: $AllNodes.Where("Role -eq Web").NodeName
    Import-DSCResource -Module PSDesiredStateConfiguration

    node ("localhost")
    {
        # Call Resource Provider
        # E.g: WindowsFeature
        
        WindowsFeatureSet IIS {
            Name                 = @("Web-Server",
                "Web-WebServer",
                "Web-Common-Http",
                "Web-Default-Doc",
                "Web-Dir-Browsing",
                "Web-Http-Errors",
                "Web-Static-Content",
                "Web-Http-Redirect",
                "Web-Health",
                "Web-Http-Logging",
                "Web-Custom-Logging",
                "Web-Log-Libraries",
                "Web-Request-Monitor",
                "Web-Http-Tracing",
                "Web-Performance",
                "Web-Stat-Compression",
                "Web-Dyn-Compression",
                "Web-Security",
                "Web-Filtering",
                "Web-Basic-Auth",
                "Web-IP-Security",
                "Web-Url-Auth",
                "Web-Windows-Auth",
                "Web-App-Dev",
                "Web-Net-Ext45",
                "Web-Asp-Net45",
                "Web-ISAPI-Ext",
                "Web-ISAPI-Filter",
                "Web-Mgmt-Tools",
                "Web-Mgmt-Console",
                "Web-Scripting-Tools",
                "NET-Framework-45-Features",
                "NET-Framework-45-Core",
                "NET-Framework-45-ASPNET",
                "NET-WCF-Services45",
                "NET-WCF-TCP-PortSharing45")
            Ensure               = "Present"
            IncludeAllSubFeature = $true
        }

        Script DownloadPackage {
            GetScript  = {
                return @{'Result' = '' }
            }
        
            SetScript  = 
            {
                $URI = $using:webZipURI
                if ((Test-Path 'c:\temp') -eq $false) { mkdir 'c:\temp' }
                Invoke-WebRequest -Uri "$URI" -OutFile "c:\temp\$(Split-Path "$URI" -Leaf)"
            }
        
            TestScript = 
            {
                $URI = $using:webZipURI
                Write-Verbose -Message "Testing DownloadPackage: $URI"
                Write-Verbose "$(Split-Path $URI -Leaf)"
                Test-Path "c:\temp\$(Split-Path "$URI" -Leaf)"
            }
        }
    
        Archive WebArchive {
            Destination = "c:\inetpub\wwwroot"
            Path        = "c:\temp\$(Split-Path -Path "$webZipURI" -Leaf)"
            DependsOn   = @("[Script]DownloadPackage", "[WindowsFeatureSet]IIS")
        } 

        <# To avoid error message "The process cannot access the file because it is being used by another process"
        File RemoveWebZip {
            DestinationPath = "c:\temp\$(Split-Path -Path "$webZipURI" -Leaf)"
            DependsOn       = "[Archive]WebArchive"
            Ensure          = "Absent" 
            Force           = $true
            Type            = "File" 
        }
        #>
    }
}
