##############################################
#   HelloWorld Custom Script Extension (CSE)
##############################################

$filePath = "c:\temp\CSEwasRunAt.txt"

#create dir if it doesn't exist
if (!(Test-Path -Path (Split-Path $filePath -Parent))) {mkdir (Split-Path $filePath -Parent)}

#write current time to file.
Get-Date | Out-File $filePath -Append

#This is really simple but imagine what else you can do to customize a vm ...