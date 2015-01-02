<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.55
	 Created on:   	5/13/2014 11:14 AM
	 Created by:   	breasor
	 Organization: 	Remy Cointreau USA
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Searches Office 365 for Distribution Groups and removes members of the group DisabledMailboxes

		To generate creds file : Get-Credential | Export-CliXml FILENAME
#>
function Cleanup-DistributionGroups
{
	param (
		[string] $DisabledGroup = "US-DisabledMailboxes",
		$credsFile = "c:\googledrive\scripts\powershell\PSOffice365-pscreds.xml"
	)
	
	begin
	{
		$DLMembers = @{ }
		$DisabledUsers = @()
		
		# Connect to Office 365 if not already connected
		if (!(Get-PSSession | Where-Object{ $_.Configurationname -eq "Microsoft.Exchange" }))
		{
			Write-Host 'Connecting to Office 365' -ForegroundColor 'Yellow'
			$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential (import-clixml $credsFile) -Authentication basic -AllowRedirection
			Import-PSSession $Session -AllowClobber
		}
		
		# Get Distribution Groups not synced by DirSync
		$DistributionGroups = Get-DistributionGroup -ResultSize Unlimited |
		where { $_.managedby -notcontains "Organization Management" }
		
		$DisabledMailboxes = Get-DistributionGroupMember $DisabledGroup
	}
	process
	{
		# Get members of group you don't want to clear
		foreach ($DisabledMailbox in $DisabledMailboxes)
		{
			$DisabledUsers += $DisabledMailbox.PrimarySmtpAddress
		}
		
		# Remove blank entries
		$DisabledUsers = $DisabledUsers | Where-Object { $_ } | sort -Unique
		
		$i = 0
		
		$progParam = @{
			Activity = "Scanning Distribution Groups"
			CurrentOperation = $DistributionGroups
			Status = "Querying Member Groups"
			PercentComplete = 0
		}
		
		Clear-Host
		
		Foreach ($DistributionGroup in $DistributionGroups)
		{
			$i++
			[int]$pct = ($i/$DistributionGroups.count) * 100
			
			$progParam.CurrentOperation = "Checking group $($DistributionGroup)"
			$progParam.Status = "Scanning"
			$progParam.PercentComplete = $pct
			
			Write-Progress @progParam
			
			#Get members of this group
			$DGMembers = Get-DistributionGroupMember -Identity $($DistributionGroup.PrimarySmtpAddress)
			
			#Iterate through each member
			Foreach ($Member in $DGMembers)
			{
				
				if (($DisabledUsers -contains $Member.PrimarySmtpAddress) -and ($DistributionGroup.Alias -ne $DisabledGroup))
				{
					Remove-DistributionGroupMember -Identity $DistributionGroup.PrimarySmtpAddress -Member $Member.PrimarySmtpAddress -confirm:$false
					#Write-Host ("{0} contains member {1}" -f $DistributionGroup, $($Member.PrimarySmtpAddress))
				}
				$progParam.CurrentOperation = "Checking user $($Member.PrimarySmtpAddress)"
				$progParam.Status = "Scanning"
				$progParam.PercentComplete = $pct
				Write-Progress @progParam
			}
		}
	}
	end
	{
		Get-PSSession | Where-Object{ $_.Configurationname -eq "Microsoft.Exchange" } | Remove-PSSession
	}
}