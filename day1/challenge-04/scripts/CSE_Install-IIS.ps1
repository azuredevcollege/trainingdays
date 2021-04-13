<#
this custom script extension installs IIS and downloads urlrewrite and install
#>


#this will be our temp folder - need it for download / logging

$tmpDir = "c:\temp\" 

#create folder if it doesn't exist
if (!(Test-Path $tmpDir)) { mkdir $tmpDir -force }

Start-Transcript "$tmpDir\Install-IIS.log"

#region install IIS features 
$features = @("Web-Server",
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

Install-WindowsFeature -Name $features -Verbose 
#endregion

#region download and install URL Rewrite Module for IIS

#download and install URL Rewrite Module for IIS
$URLRewrite2_1 = "http://download.microsoft.com/download/D/D/E/DDE57C26-C62C-4C59-A1BB-31D58B36ADA2/rewrite_amd64_en-US.msi"
$URLRewrite2_1Path = $tmpDir + "\$(Split-Path $URLRewrite2_1 -Leaf)"
if (!(Test-Path $URLRewrite2_1Path )) {
    #download if not there

    start-bitstransfer "$URLRewrite2_1" "$URLRewrite2_1Path" -Priority High -RetryInterval 60 -Verbose -TransferType Download #wait until downloaded.

}

#unattended install
start-process -filepath msiexec -ArgumentList "/i ""$URLRewrite2_1Path"" /l*v ""$URLRewrite2_1Path.log""  /passive ACCEPTEULA=""YES""" -Wait

#endregion

Stop-Transcript