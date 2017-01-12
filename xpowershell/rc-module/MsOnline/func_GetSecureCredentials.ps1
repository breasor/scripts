Function Get-SecureCredentials
{
<#
.SYNOPSIS
    Creates a secure XML file specific for computer you are on with credentials to use to authentication with Office 365 for powershell

.DESCRIPTION
    creates and optionally stores a secure XML file with credentials to authenticate with Office 365 for powershell.  
    
    You can use the -Save $false if you don't want to sae the credentials.

.EXAMPLE
    $credentials = Get-SecureCredentials -AdminName a-breasor@remyusa.com
    
    This example puts your credentials into an XML file if it doesn't exist
    
    PS C:\> $credentials = Get-SecureCredentials -AdminName a-breasor@remyusa.com
    
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $credentials -Authentication basic -AllowRedirection

.EXAMPLE
    $credentials = Get-SecureCredentials -AdminName a-breasor@remyusa.com -Save $false

    This example creates a temporary credential for use in Office 365 Powershell
    
    PS C:\> $credentials = Get-SecureCredentials -AdminName a-breasor@remyusa.com -Save $false

#>
	param (
        [Parameter(Mandatory=$true)]
        [string]$AdminName,
		[bool]$save = $true
	)
	
    $credsFile = Join-Path $env:appdata "$(($adminName -split "@")[0])_msolcred.xml"

    if (-not (Test-Path $credsFile))
    {
        Write-Verbose "No Saved Credentials. Getting Credentials for $($AdminName)"
        $MsolCredential = Get-Credential $AdminName
        if ($Save) { $MsolCredential | Export-Clixml $credsFile  }
    }
    
    return (Import-Clixml $credsFile)
	
	
}