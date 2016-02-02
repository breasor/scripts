<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.74
	 Created on:   	11/17/2014 9:36 AM
	 Created by:   	breasor
	 Organization: 	Remy Cointreau USA
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
[cmdletbinding()]
Param ()

begin
{
	Import-Module MSOnlineExtended
	
	$saved = $global:ErrorActionPreference
	$global:ErrorActionPreference = 'stop'
	
	$smtpserver = "smtp.remyusa.com"
	$sender = "powershell@remy-cointreau.com"
	#$recipients="it-france@remy-cointreau.com","prestataires-support@remy-cointreau.com","it-prague@remy-cointreau.com","it-glasgow@remy-cointreau.com","it-islay@remy-cointreau.com","it-new-york@remy-cointreau.com","it-barbados@remy-cointreau.com","it-shanghai@remy-cointreau.com","it-singapore@remy-cointreau.com"
	$recipients = "brett.reasor@remyusa.com"
	#$cc="info.controles@remy-cointreau.com"
	$cc = "nobody@remyusa.com"
	
	$UserReport = "C:\Scripts\Reports\UserReport.csv"
	$AdminReport = "C:\Scripts\Reports\AdminReport.csv"
	$HTMLReport = "C:\Scripts\Reports\LicenseReport.html"
	
	$HTMLHeader = Get-Content "C:\Scripts\PowerShell\HeaderFile.txt"
	$HTMLFooter = "</div></body></html>"
	
	function _GetMsolRole
	{
		$AdminUsers = @{ }
		
		$MsolRole = Get-MsolRole
		$Roles = @($MsolRole | Select-Object name).name
		$Roles
		
		$MsolRole | foreach-object {
			$RoleName = $_.name
			$MsolAdmin = Get-MsolRoleMember -RoleObjectId $_.objectId
			$MsolAdmin | where { $_.RoleMemberType -eq "User" } | ForEach {
				$EmailAddress = $_.EmailAddress
				$Admin = $MsolUsers | Where-Object { $_.userprincipalname -eq $EmailAddress }
				$MsolAdminObject = [pscustomobject][ordered]@{
					DisplayName = $Admin.DisplayName
					UserPrincipalName = $Admin.UserPrincipalName
					UsageLocation = $Admin.UsageLocation
					IsLicensed = $Admin.IsLicensed
				}
				#$Roles
				switch ($RoleName) { { $Roles.contains($_) } { $MsolAdminObject | Add-Member -Name "Role" -Type 'NoteProperty' -Value $_ -Force } }
				
				$AdminUsers.Add($_.EmailAddress, $MsolAdminObject)
			}
			
		}
		
		return $AdminUsers
		
	}
	function Generate-LicenseUserTable
	{
		param (
			$object,
			[string] $SortOrder,
			[string] $headerstring
		)
		
		$Count = $object.count
		if ($Count -gt 0)
		{
			$HTMLResult = "<h2>$($headerstring) - ($($Count))</h2>"
			$HTMLResult += "<table><tr><th>Display Name</th><th>User Principal Name</th><th>Company</th><th>Office</th><th>Location</th><th>Country</th><th>Last Logged On</th><th>License</th></tr>"
			
			$object | Sort-Object $SortOrder |
			ForEach-Object {
				$HTMLResult += "<tr>"
				$HTMLResult += "<td>" + $_.DisplayName + "</td>"
				$HTMLResult += "<td>" + $_.UserPrincipalName + "</td>"
				$HTMLResult += "<td>" + $_.Company + "</td>"
				$HTMLResult += "<td>" + $_.Office + "</td>"
				$HTMLResult += "<td>" + $_.UsageLocation + "</td>"
				$HTMLResult += "<td>" + $_.CountryOrRegion + "</td>"
				$HTMLResult += "<td>" + $_.LastLogonTime + "</td>"
				$HTMLResult += "<td>" + $_.LicenseSKU + "</td>"
				$HTMLResult += "</tr>"
			}
			$HTMLResult += "</table>"
		}
		return $HTMLResult
	}
	
	function Generate-AdminUserTable
	{
		param (
			$object,
			[string] $SortOrder,
			[string] $headerstring
		)
		
		$Count = $object.count
		if ($Count -gt 0)
		{
			$HTMLResult = "<h2>$($headerstring) - ($($Count))</h2>"
			$HTMLResult += "<table><tr><th>Display Name</th><th>User Principal Name</th><th>Location</th><th>Is Licensed</th></tr>"
			
			$object | Sort-Object $SortOrder |
			ForEach-Object {
				$HTMLResult += "<tr>"
				$HTMLResult += "<td>" + $_.DisplayName + "</td>"
				$HTMLResult += "<td>" + $_.UserPrincipalName + "</td>"
				$HTMLResult += "<td>" + $_.UsageLocation + "</td>"
				$HTMLResult += "<td>" + $_.IsLicensed + "</td>"
				$HTMLResult += "</tr>"
			}
			$HTMLResult += "</table>"
		}
		return $HTMLResult
	}
	
	function _GetLicenseStatus
	{
		$AccountSKU = Get-MsolAccountSku
		$HTMLResult = "<h2>License Status</h2><table><tr><th>Account SKU Id</th><th>Active</th><th>Used</th><th>Available</th></tr>"
		foreach ($SKU in $AccountSKU)
		{
			# Line 1
			$HTMLResult += "<tr>"
			$HTMLResult += "<td>" + $SKU.AccountSKUId + "</td>"
			$HTMLResult += "<td>" + $SKU.ActiveUnits + "</td>"
			$HTMLResult += "<td>" + $SKU.ConsumedUnits + "</td>"
			$HTMLResult += "<td>" + ($SKU.ActiveUnits - $SKU.ConsumedUnits) + "</td>"
			$HTMLResult += "</tr>"
		}
		$HTMLResult += "</table>"
		
		$ActiveCount = (($AccountSku | where { $_.ActiveUnits -gt 1 }).ActiveUnits | Measure-Object -sum).sum
		$ConsumedCount = (($AccountSku | where { $_.ActiveUnits -gt 1 }).ConsumedUnits | Measure-Object -sum).sum
		
		$AvailableLicenses = $ActiveCount - $ConsumedCount
		$ReturnObject = @{ }
		$ReturnObject.AvailableLicenses = $AvailableLicenses
		$ReturnObject.HTMLResult
		return $ReturnObject
	}
	
	function _GetUsers
	{
		$MsolUsers | foreach {
			
			Write-Verbose "Gathering User Information for $($_.userprincipalname)"
			
			if (!($_.LastDirSyncTime)) { $SyncStatus = 'Cloud' }
			else { $SyncStatus = 'ActiveDirectory' }
			
			$Licenses = New-Object "System.Collections.Generic.List[string]"
			$services = ($_.licenses[0].ServiceStatus | where { $_.ProvisioningStatus -eq "Success" }).serviceplan.servicename
			
			switch -wildcard ($services)
			{
				"EXC*" { $Licenses.Add("Exchange Online") }
				"MCO*" { $Licenses.Add("Lync Online") }
				"LYN*" { $Licenses.Add("Lync Online") }
				"OFF*" { $Licenses.Add("Office Profesional Plus") }
				"SHA*" { $Licenses.Add("Sharepoint Online") }
				"*WAC*" { $Licenses.Add("Office Web Apps") }
				"WAC*" { $Licenses.Add("Office Web Apps") }
				default { $Licenses.Add($services.ServicePlan.servicename) }
			}
			
			$UserObject = [pscustomobject][ordered]@{
				DisplayName = $_.DisplayName
				Title = $Users[$_.userprincipalname].Title
				UserPrincipalName = $_.userprincipalname
				UsageLocation = $_.UsageLocation
				CountryOrRegion = $Users[$_.userprincipalname].CountryOrRegion
				Company = $Users[$_.userprincipalname].Company
				Office = $Users[$_.userprincipalname].Office
				StateOrProvince = $Users[$_.userprincipalname].StateOrProvince
				City = $Users[$_.userprincipalname].City
				Phone = $Users[$_.userprincipalname].Phone
				Mobile = $Users[$_.userprincipalname].MobilePhone
				LicenseSKU = $_.Licenses.AccountSKUId
				Licenses = $Licenses
				BlockCredential = $_.BlockCredential
				SyncStatus = $SyncStatus
				PasswordNeverExpires = $_.PasswordNeverExpires
				
			}
			
			$UserAccounts[$_.userprincipalname] += $UserObject
		}
		
		
		foreach ($u in $UserAccounts.Values)
		{
			Write-Verbose "Gathering Mailbox Statistics for $($u.userprincipalname)..."
			$Mailbox = $Mailboxes.Values | Where-Object { $_.userprincipalname -eq $u.Userprincipalname }
			if ($Mailbox.exchangeguid)
			{
				$UserAccounts[$u.userprincipalname] | Add-Member -Name "SMTP_Domain" -Type 'NoteProperty' -Value $Mailbox.PrimarySMTPAddress.split("@")[1]
				$Stats = Get-MailboxStatistics -Identity "$($Mailbox.exchangeguid)" -ErrorAction 'SilentlyContinue' | Select-Object Displayname, MailboxGuid, StorageLimitStatus, ItemCount, LastLogonTime, @{ name = "TotalItemSize"; expression = { [math]::Round((($_.TotalItemSize.Value.ToString()).Split("(")[1].Split(" ")[0].Replace(",", "")/1MB), 2) } }, @{ name = "TotalDeletedItemSize"; expression = { [math]::Round((($_.TotalDeletedItemSize.Value.ToString()).Split("(")[1].Split(" ")[0].Replace(",", "")/1MB), 2) } }
				$UserAccounts[$u.userprincipalname] | Add-Member -Name "RecipientTypeDetails" -Type 'NoteProperty' -Value $Mailbox.RecipientTypeDetails
				$UserAccounts[$u.userprincipalname] | Add-Member -Name "LastLogonTime" -Type 'NoteProperty' -Value $stats.LastLogonTime
				$UserAccounts[$u.userprincipalname] | Add-Member -Name "TotalItemSize" -Type 'NoteProperty' -Value $stats.TotalItemSize
				$UserAccounts[$u.userprincipalname] | Add-Member -Name "TotalDeletedItemSize" -Type 'NoteProperty' -Value $stats.TotalDeletedItemSize
			}
		}
	}
	
}
process
{
	
	# Get MS Licensed Users
	#
	Write-Verbose "Running (Get-MsolUser -All)..."
	#$MsolUsers = Get-MsolUser -All
	#$MsolUsers | Export-Clixml c:\Scripts\XML\AllMsolUser.xml -Depth 4
	$MsolUsers = Import-Clixml c:\Scripts\XML\AllMsolUser.xml
	
	# Get All Users Data
	#
	Write-Verbose "Running (Get-User -ResultSize Unlimited)..."
	Get-User -ResultSize Unlimited | select UserPrincipalname, City, Company, CountryOrRegion, Department, DisplayName, MobilePhone, Phone, Office, StateOrProvince, Title | foreach { $Users = @{ } } { $Users[$_.UserPrincipalName] = $_ }
	$Users | Export-Clixml C:\Scripts\XML\AllUsers.xml
	$Users = Import-Clixml c:\Scripts\XML\AllUsers.xml
	
	Write-Verbose "Running (Get-Mailbox -ResultSize Unlimited)..."
	Get-Mailbox -ResultSize Unlimited -Filter { (RecipientTypeDetails -eq "UserMailbox") -or (RecipientTypeDetails -eq "User") -or (RecipientTypeDetails -eq "SharedMailbox") } | select UserPrincipalName, PrimarySMTPAddress, exchangeguid, RecipientTypeDetails | foreach { $Mailboxes = @{ } } { $Mailboxes[$_.PrimarySMTPAddress] = $_ }
	$Mailboxes | Export-Clixml C:\Scripts\XML\AllMailbox.xml
	$Mailboxes = Import-Clixml C:\Scripts\XML\AllMailbox.xml
	
	$UserAccounts = @{ }
	
	_GetUsers
	$UserAccounts | Export-Clixml C:\Scripts\XML\UserAccounts.xml
	
	$UserAccounts = Import-Clixml c:\Scripts\XML\UserAccounts.xml
	
	$UserAccounts.Values |
		select SMTP_Domain, UserPrincipalname, DisplayName, LicenseSKU, CountryOrRegion, Office, SyncStatus, BlockCredential, RecipientTypeDetails, lastLogonTime, UsageLocation, StateOrProvince, city, passwordneverexpires, phone, mobile, title |
			Export-Csv $UserReport -NoTypeInformation
	
	
	
	$Admins = _GetMsolRole
	$Admins | Export-Clixml C:\Scripts\XML\Admins.xml
	$Admins.Values | Export-Csv $AdminReport -NoTypeInformation
	
	$LicenseStatus = _GetLicenseStatus
	
	$StatusHTML = $LicenseStatus.HTMLResult
	
	$AdminHTML = ""
	foreach ($role in $roles)
	{
		$AdminHTML += Generate-AdminUserTable ($Admins.values | Where { $_.Role -eq $role }) "Role" $role
	}ge
	
	
	$LicenseTableHTML = ""
	$LicenseTableHTML += Generate-LicenseUserTable ($UserAccounts.Values | where { ($_.recipienttypedetails -eq "UserMailbox") -and ($_.BlockCredential -eq $true) }) "UsageLocation" "Credential Is Blocked"
	$LicenseTableHTML += Generate-LicenseUserTable ($UserAccounts.Values | Where { ($_.recipienttypedetails -eq "UserMailbox") -and ($_.LastLogonTime -lt ((Get-Date).AddDays(-30))) -and !($_.LastLogonTime -lt ((Get-Date).AddDays(-90))) }) "LastLogonTime" "No logon from 30 to 90 days"
	$LicenseTableHTML += Generate-LicenseUserTable ($UserAccounts.Values | where { ($_.recipienttypedetails -eq "UserMailbox") -and ($_.LastLogonTime -lt ((Get-Date).AddDays(-90))) }) "LastLogonTime" "No Logon greater than 90 days"
	$LicenseTableHTML += Generate-LicenseUserTable ($UserAccounts.Values | where { ($_.recipienttypedetails -eq "SharedMailbox") -and ($_.LicenseSKU) }) "UsageLocation" "Shared Mailbox taking User License"
	
	
	$body = $HTMLHeader + $StatusHTML + $LicenseTableHTML + $AdminHTML + $HTMLFooter
	
	
	
}
end
{
	$body | Out-File $HTMLReport
	
	$subject = "Office 365: $($LicenseStatus.AvailableLicenses) Free Licenses & $($Admins.Values.count) Administrators"
	
	Send-MailMessage -From $sender -Subject $subject -To $recipients -Attachments $HTMLReport, $UserReport, $AdminReport -Body $body -BodyAsHtml -Cc $cc -SmtpServer $smtpserver
}