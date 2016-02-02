<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.82
	 Created on:   	8/13/2015 3:13 PM
	 Created by:   	breasor
	 Organization: 	Remy Cointreau USA
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
# Script to retrieve a licensing report from Office 365 and output it to CSV

# DISCLAIMER

# The sample scripts are not supported under any Microsoft standard support program or service.

# The sample scripts are provided AS IS without warranty of any kind.

# The entire risk arising out of the use or performance of the sample scripts and documentation remains with you.

# Created by Ted Giesler http://blog.cypgrp.com

Function Get-FileName($initialDirectory)
{
	
	[System.Reflection.Assembly]::LoadWithPartialName(“System.windows.forms”) | Out-Null
	
	$OpenFileDialog = New-Object System.Windows.Forms.SaveFileDialog
	
	$OpenFileDialog.initialDirectory = $initialDirectory
	
	$OpenFileDialog.filter = “All files (* . *) | * . * ”
	
	$OpenFileDialog.ShowDialog() | Out-Null
	
	$OpenFileDialog.filename
	
	If ($Show -eq “OK”)
	{
		
		Return $objForm.FileName
		
	}
	
	Else
	{
		
		Write-Error “Operation cancelled by user.”
		
		Exit
		
	}
	
} #end function Get-FileName

# *** Entry Point to Script ***

# load the MSOnline PowerShell Module

# verify that the MSOnline module is installed and import into current powershell session
<#
If (!([System.IO.File]::Exists((“{ 0 }\modules\msonline\Microsoft.Online.Administration.Automation.PSModule.dll” -f $pshome))))
{
	
	Write-Host “The Microsoft Online Services Module for PowerShell is not installed. The Script cannot continue.”
	
	write-host “Please download and install the Microsoft Online Services Module.”
	
	Exit
	
}
#>

[string[]] $log = @()

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
	Import-PSSession $Session -AllowClobber
	Import-Module MSOnline
	Connect-MsolService -Credential (import-clixml $credsFile)
	
	if (!$?)
	{
		Write-Error -Message "Failed Importing the Microsoft Exchange Session, exiting!"  
	}
}

Connect-ExchangeOnline -AdminName a-breasor@remyusa.com

$users = Get-MsolUser -All
$mailboxes = Get-Mailbox -ResultSize Unlimited
$mailstats = $mailboxes | Get-MailboxStatistics | Select-Object -Property @{ l = 'UserName'; e = { $_.LegacyDN.split('-')[-1] } }, LastLogonTime

$output = foreach ($user in $users)
{
	if ($user.licenses[0].accountskuid)
	{
		#$skuid = $user.licenses[0].accountskuid.split(':')[1]
		switch -wildcard ($user.licenses[0].accountskuid)
		{
			"*:DESKLESSPACK" { $license = 'K1' }
			"*:STANDARDPACK" { $license = 'E1' }
			"*:STANDARDWOFFPACK" { $license = 'E2' }
			"*:ENTERPRISEPACK" { $license = 'E3' }
			default { $license = "Unknown: $($user.licenses[0].accountskuid)" }
		}
		
		$UserName = $user.UserPrincipalName.Split('@')[0]
		[string]$CreationDate = $mailboxes | Where-Object -Filter { $_.UserPrincipalName -eq $user.UserPrincipalName } | Select-Object -ExpandProperty WhenCreated
		[string]$LastLogonDate = $mailstats | Where-Object -Filter { $_.UserName -eq $UserName } | Select-Object -ExpandProperty LastLogonTime
		
		if ($LastLogonDate -eq $null) { $LastLogonDate = 'Never' }
		
		$props = [ordered]@{
			'DisplayName' = $user.DisplayName;
			'UserName' = $UserName;
			'Department' = $user.Department;
			'CreationDate' = $CreationDate;
			'EmailAddress' = $user.UserPrincipalName;
			'LastLogonDate' = $LastLogonDate;
			'License' = $license
		}
		$obj = New-Object -Type PSObject -Property $props
		Write-Output $obj
	}
}

Get-PSSession | Where-Object{ $_.Configurationname -eq "Microsoft.Exchange" } | Remove-PSSession