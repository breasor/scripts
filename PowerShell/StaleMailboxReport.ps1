<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.82
	 Created on:   	8/18/2015 8:52 AM
	 Created by:   	breasor
	 Organization: 	Remy Cointreau USA
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
Import-Module MSOnline

$staleMail = Get-StaleMailboxDetailReport -StartDate (get-date).AddDays(-2) -EndDate (get-date).AddDays(-1)


foreach ($mailbox in $staleMail) {
	$msolUser = get-msoluser -userprincipalname $mailbox.windowsliveid
	if ($msolUser.isLicensed)
	{
		Get-Mailbox $mailbox.windowsliveid
	}
}

