Function Disconnect-ExchangeOnline
{
<#
.SYNOPSIS
   Disconnects Exchange Onlie Session

.DESCRIPTION
   Disconnects Exchange Onlie Session
#>
	Get-PSSession | Where-Object{ $_.Configurationname -eq "Microsoft.Exchange" } | Remove-PSSession
}