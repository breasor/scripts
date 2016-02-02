<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.82
	 Created on:   	8/17/2015 9:57 AM
	 Created by:   	breasor
	 Organization: 	Remy Cointreau USA
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

Function Sync-ADchanges
{
	$ocsess = New-PSSession -ComputerName frcng0pas66
	Invoke-Command -Session $ocsess -ScriptBlock { Add-PSSnapin coexistence-configuration }
	Invoke-Command -Session $ocsess -ScriptBlock { Start-OnlineCoexistenceSync -verbose }
	Remove-PSSession $ocsess
	
}

Function Update-SecureCredentials
{
	param (
		[Parameter(Mandatory = $true)]
		[string]$AdminName
	)
	if (!(Test-Path -path "C:\exploit")) { New-Item "C:\exploit" -Type Directory }
	$credsFile = "c:\exploit\$([environment]::MachineName)-$($AdminName)-pscreds.xml"
	Get-Credential $AdminName | Export-Clixml $credsFile
}

function Connect-ExchangeOnline
{
	param (
		[Parameter(Mandatory = $true)]
		[string]$AdminName
	)
	
	$credsFile = "c:\exploit\$([environment]::MachineName)-$($AdminName)-pscreds.xml"
	
	if (-not (Test-Path $credsFile))
	{
		$credentials = Get-Credential -Credential $AdminName
	}
	else
	{
		$credentials = Import-Clixml $credsFile
	}
	
	Write-Host 'Connecting to Office 365' -ForegroundColor 'Yellow'
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $credentials -Authentication basic -AllowRedirection
	#Import-PSSession $Session
	Import-Module (Import-PSSession $Session -AllowClobber) -Global
	Import-Module MSOnline
	Connect-MsolService -Credential $credentials
	
	if (!$?)
	{
		Write-Error -Message "Failed Importing the Microsoft Exchange Session, exiting!"
	}
}

Function Disconnect-ExchangeOnline
{
	Get-PSSession | Where-Object{ $_.Configurationname -eq "Microsoft.Exchange" } | Remove-PSSession
}

function Get-MailboxByDomain
{
	param (
		[Parameter(Mandatory = $true)]
		[string]$DomainName
	)
	
	Get-Mailbox -Filter "UserPrincipalName -like '*$($DomainName)'"
}

Function FindDisabledOU
{
	param (
		[Parameter(Mandatory = $true)]
		[string]$strUser
	)
	if ($strUser -eq $Null) { return $null }
	else
	{
		$baseOU = ($strUser -split ",", 2)[1]
		$strOU = "$DisabledOU,$baseOU"
		return $strOU
	}
}

Export-ModuleMember Connect-ExchangeOnline, Disconnect-ExchangeOnline, Sync-ADChanges, Get-MailboxByDomain, FindDisabledOU