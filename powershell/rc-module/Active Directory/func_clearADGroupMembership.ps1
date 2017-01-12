Function Clear-ADGroupMemberShip {
<#
.SYNOPSIS
    Clears Group Membership of user in Active Directory
.DESCRIPTION
    Clears Group Membership of user in Active Directory
.EXAMPLE
    Clear-ADGroupMemberShip -Identity some.user
    
    Clears all group memberships for user

.PARAMETER Identity
    AD SamAccountName, can be taken from Pipeline
#>
    param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [ValidateScript({
            $Identity = $PSItem
            if ((Get-ADUser -Identity $Identity)) { $true }
            else { throw "User does not exist" }
       })]
    [string]$Identity
    )

    $adgroups = Get-ADPrincipalGroupMembership -Identity $Identity
    $adgroups | ForEach-Object { if ((Get-ADGroup $_ -Properties mail).mail) { Remove-ADGroupMember -Members $Identity -Identity $_ }}
}