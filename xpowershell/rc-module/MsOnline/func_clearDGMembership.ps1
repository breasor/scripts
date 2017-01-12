Function Clear-DGMemberShip {
<#
.SYNOPSIS
    Clears Group Membership of user in Office 365
.DESCRIPTION
    Clears Group Membership of user in Office 365
.EXAMPLE
    Clear-DGMemberShip -Identity some.user@contoso.com
    
    Clears all group memberships for user

.EXAMPLE
    Get-Mailbox -identity user@contoso.com | Clear-DGMemberShip 
    
    Clears all group memberships for user

.PARAMETER Identity
    Office 365 Identity, can be taken from Pipeline
#>
    param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [ValidateScript({
            $Identity = $PSItem
            if (($Identity = Get-Recipient $Identity -Erroraction stop).RecipientType -eq "UserMailbox") { $True }
            else { Throw "Mailbox does not exist for user: $($Identity)" }
       })]
    [string]$Identity
    )
    
    $distinguishedName =  (Get-Mailbox -Identity $Identity).distinguishedname

            $group = Get-DistributionGroup -Filter "Members -like '$($distinguishedName)'" -ErrorAction silentlycontinue 
            if ( $group -notlike "*Disabled*") { $group |  foreach-object { Remove-DistributionGroupMember -Identity $_.identity -Member $distinguishedName -Confirm:$false}}
}