Function Disable-UserMailbox {
    param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [ValidateScript({
                      $Identity = $PSItem
                       if (!(Get-PSSession | Where-Object{ $_.Configurationname -eq "Microsoft.Exchange" })) { 
                        $Credentials = Get-Credential (get-aduser $env:username).userprincipalname
                        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Credentials -Authentication basic -AllowRedirection 
                        Import-Module (Import-PSSession $Session -AllowClobber) -Global 
                        Import-Module MSOnline
		                Connect-MsolService -Credential $Credentials	
                      }  
                      if ((Get-Recipient $Identity -Erroraction stop).RecipientType -eq "UserMailbox") { $True }
                      else { Throw "Mailbox does not exist for user: $($Identity)" }
                    })]
    [string]
    $Identity,
    [string]$SecurityGroup = "SG_USExEmployee",
    [Parameter(Mandatory=$true)]
    [ValidateSet("Americas","Europe", "Asia", "RCUSA")]
    [string]$Zone,
    [bool]$Clear,
    [Parameter(Mandatory=$true)]
    [bool]$OutOfOffice
    )



    $Mailbox = Get-Mailbox $Identity
    $ADUser = Get-ADUser -Filter "userprincipalname -eq '$($Mailbox.UserPrincipalName)'" -Properties Manager, DisplayName, company

    if (!($Mailbox.RecipientTypeDetails -eq "SharedMailbox")) { 
        # Convert to Shared Mailbox
        $sharedAttributes = @{ Type = "Shared" }
	    Set-Mailbox -Identity $Mailbox.Identity  @sharedAttributes 
        Set-ADUser -identity $ADUser.samaccountname -Replace @{ msExchRemoteRecipientType = "100" } 
    
        # Disable all kinds of access
	    $casAttributes = @{ ActiveSyncEnabled = [Boolean]"False"; MAPIEnabled = [Boolean]"False"; imapenabled = [Boolean]"False"; popenabled = [Boolean]"False" }
	    Set-CASMailbox -identity $Mailbox.identity @casAttributes 
    }

    $licenseSKU = (Get-MsolUser -userprincipalname $Mailbox.UserPrincipalName).Licenses.AccountSKUID

    if ($licenseSKU) { $licenseSKU | % { Set-MsolUserLicense -UserPrincipalName $Mailbox.UserPrincipalName -RemoveLicenses $_ 
                        }}   
    
    # Give Security Group Rights
    Add-RecipientPermission -Identity $Mailbox.Identity -AccessRights SendAs -Trustee $SecurityGroup -Confirm:$False 
    Add-MailboxPermission -Identity $Mailbox.Identity -User $SecurityGroup -AccessRights fullaccess -Automapping $false -Confirm:$False 

    # Clear Distribution Group Membership and add to disabled mailbox
    $group = Get-DistributionGroup -Filter "Members -like '$($Mailbox.DistinguishedName)'" -ErrorAction silentlycontinue 
    $group |  foreach-object { Remove-DistributionGroupMember -Identity $_.identity -Member $Mailbox.DistinguishedName -Confirm:$false}
    Add-DistributionGroupMember -Identity "$($Zone)-disabled-mailboxes" -Member $Mailbox.Identity

    # Clear user from AD Security groups with email
    $adgroups = Get-ADPrincipalGroupMembership -Identity $ADUser.DistinguishedName
    $adgroups | ForEach-Object { if ((Get-ADGroup $_ -Properties mail).mail) { Remove-ADGroupMember -Members $ADUser.DistinguishedName -Identity $_ -WhatIf }}

    #if ((Get-DistributionGroupMember "$($Zone)-disabled-mailboxes").distinguishedname -notcontains $mailbox.DistinguishedName) {  }




    if (!($ADUser.Enabled)) {
        # Disable AD Account
	    Disable-ADAccount -Identity $ADUser.DistinguishedName -Confirm:$False -ErrorAction SilentlyContinue
		
	    # Set customAttribute10 to current date
	    Set-ADUser -Identity $ADUser.DistinguishedName -Replace @{ extensionAttribute10 = (get-date -Format o).ToString() } 
    }


    if ($OutOfOffice) {
        $Manager = Get-ADUser -Identity $ADUser.manager -Properties telephoneNumber, mail, DisplayName

	    if ($Manager)

	    {
		    #$Manager = get-mailbox -identity $ManagerIdentity
		    $OOOMessage = ("{0} is no longer with {1}.<br><br>Please contact {2} 
			    - {3} or {4} for assistance.<br><br>" -f $ADUser.displayname, $ADUser.company, $Manager.DisplayName, $Manager.mail, $manager.telephoneNumber)

		    Add-RecipientPermission -Identity $ADUser.Userprincipalname -AccessRights SendAs -Trustee $Manager.Userprincipalname -Confirm:$False 
		    Add-MailboxPermission -Identity $ADUser.Userprincipalname -User $Manager.Userprincipalname -AccessRights fullaccess -Confirm:$False 
	    }
		
	    elseif ($zone -eq "RCUSA")
	    {
		    Write-Host ("User {0} has no Manager.  Setting default Out of Office" -f $ADUser.displayname) -ForegroundColor DarkRed -BackgroundColor Yellow
			
		    $OOOMessage = ("{0} is no longer with {1}.<br><br>Please contact our main office at +1 212-399-4200 if you have any questions<br><br>" -f $ADUser.displayname, $ADUser.Company)
	    }

	    else
	    {
		    Write-Host ("User {0} has no Manager.  Setting default Out of Office" -f $ADUser.displayname) -ForegroundColor DarkRed -BackgroundColor Yellow
			
		    $OOOMessage = ("{0} is no longer with {1}" -f $ADUser.displayname, $ADUser.Company)
        }
        Set-MailboxAutoReplyConfiguration -Identity $User.Identity -AutoReplyState Enabled -ExternalAudience All `
			    -InternalMessage $OOOMessage -ExternalMessage $OOOMessage -Confirm:$False 
    
    }

    if ($clear) {
        Set-ADUser -Identity $ADUser.distinguishedname -Clear Manager, department, division, company, physicalDeliveryOfficeName 
        Set-ADUser -Identity $ADUser.distinguishedname -Replace @{ msExchHideFromAddressLists = "TRUE" ; description = "disabled user"} 
     }

    $newOU = "OU=@disabled," + ($Aduser.DistinguishedName -split ",", 2)[1] 
    if ($ADUser.DistinguishedName -notmatch "OU=@disabled") { Move-ADObject -Identity $ADUser.DistinguishedName -TargetPath $newOU -ErrorAction SilentlyContinue }
}