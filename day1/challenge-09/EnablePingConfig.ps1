configuration AllowPing
{
    # One can evaluate expressions to get the node list
    # E.g: $AllNodes.Where("Role -eq Web").NodeName
    node ("localhost")
    {

        Script Netfirewall {
            GetScript  = {
                (Get-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)") }
            SetScript  = {
                Enable-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" 
            }
            TestScript = {
                return (Get-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)").Enabled -eq $true
            }
        }
    }
}