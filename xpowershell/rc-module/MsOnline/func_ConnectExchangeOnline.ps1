function Connect-ExchangeOnline
{

<#
.SYNOPSIS
    Connects to exchange online using your stored XML credentials file

.DESCRIPTION
    Uses a stored credential from Get-MSOLCredentials and authenticates to Office 365 Powershell

.EXAMPLE
    This example gets your credentials from an XML file and if it doesn't exist, creates one then logs you into Office 365.
    
    $credentials = Get-SecureCredentials -AdminName a-breasor@remyusa.com
    
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $credentials -Authentication basic -AllowRedirection



#>
	param (
		[Parameter(Mandatory = $true)]
		[string]$AdminName
	)
	
	$credentials = Get-SecureCredentials -AdminName $AdminName
	
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