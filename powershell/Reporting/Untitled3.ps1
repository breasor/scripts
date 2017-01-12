
$userList = @()
$licensedUsers = @()
$servicePlans = @()

foreach ($user in (Get-MsolUser  -All)) {
#foreach ($user in (Get-MsolUser  -MaxResults 10)) {
#foreach ($user in $msolUsers) {

    $userObject = @{}
    $userObject.objectId = $user.objectId
    $userObject.whencreated = $user.whencreated
    $userObject.isLicensed = $user.isLicensed
    $userObject.BlockCredential = $user.BlockCredential
    $userObject.Department = $user.Department
    $userObject.Country = $user.Country
    $userObject.SignInName = $user.SignInName
    $userObject.State = $user.State
    $userObject.Title = $user.Title
    $userObject.usagelocation = $user.usagelocation
    $userObject.immutableid = $user.immutableid
    $userObject.LastDirSyncTime = $user.LastDirSyncTime
    $userObject.DisplayName = $user.DisplayName
    $userObject.UserPrincipalName = $user.UserPrincipalName
    $userObject.CloudExchangeRecipientDisplayType = $user.CloudExchangeRecipientDisplayType
    $userObject.City = $user.City
    $userList += New-Object -TypeName PSObject -Property $userObject
    $upn = $user.UserPrincipalName
    $objectId = $user.objectId
    foreach ($license in $user.Licenses) {
        $licenseObject = @{}
        $licenseObject.UserPrincipalName = $upn
        $licenseObject.objectId = $objectId
        $licenseObject.AccountSKUId = $license.AccountSKU.SkuPartNumber
        $licensedUsers += New-Object -TypeName PSObject -Property $licenseObject
    }
    foreach ($plan in $user.Licenses.servicestatus) {
        $serviceObject = @{}
        $serviceObject.UserPrincipalName = $upn
        $serviceObject.objectId = $objectId
        $serviceObject.ServicePlan = $plan.serviceplan.ServiceName
        $serviceObject.ProvisioningStatus = $plan.ProvisioningStatus
        $servicePlans += New-Object -TypeName PSObject -Property $serviceObject
    }
}
                  
$adminRoles = @()
ForEach ($role in (Get-MsolRole)) {
    $adminObject = @{}
    $adminRoles  += Get-MsolRoleMember -RoleObjectId $role.objectid | 
        Select-Object  objectId,
                       DisplayName,
                       EmailAddress,
                       IsLicensed,
                       RoleMemberType,
                       @{name="RoleName";expression={$role.Name}},
                       @{name="StrongAuthentication";expression={$_.StrongAuthenticationRequirements.State}} 
       
        
}

$accountSkus = @(Get-MsolAccountSku | 
    Where-Object {$_.ConsumedUnits -ge 1}  |  
    Select-Object SkuPartNumber, 
           ActiveUnits, 
           ConsumedUnits, 
           @{name="FreeUnits";expression={($_.ActiveUnits - $_.ConsumedUnits)}})

$accountSkus  | Export-Csv -NoTypeInformation C:\exploit\tosharepoint\AccountSKUs.csv
$userList | Export-Csv -NoTypeInformation C:\exploit\tosharepoint\MsolUsers.csv
$licensedUsers | Export-Csv -NoTypeInformation C:\exploit\tosharepoint\LicensedAccounts.csv
$servicePlans | Export-Csv -NoTypeInformation C:\exploit\tosharepoint\ServicePlans.csv
$adminRoles | Export-Csv -NoTypeInformation C:\exploit\tosharepoint\AdminRoles.csv

<#
$mailboxUsers = @()
foreach ($mailbox in (Get-Mailbox  -ResultSize Unlimited | Select-Object ExchangeGuid, IsShared, SamAccountName, ServerName, Office, UserPrincipalName, MailboxPlan, ArchiveStatus, ArchiveState, RemoteRecipientType, SKUAssigned, IsInactiveMailbox, IsDirSynced, Alias, DisplayName, RecipientTypeDetails, Identity, Name, WhenCreated, DistinguishedName)) {
    $DistinguishedName = $mailbox.DistinguishedName
    
    $mboxStats = (Get-MailboxStatistics -Identity $DistinguishedName | Select-Object IsClutterEnabled,lastlogontime, TotalItemSize, TotalDeletedItemSize, ItemCount, LastLoggedOnUserAccount)
    $mboxObject = @{}
    $mboxObject.ExchangeGuid = $mailbox.ExchangeGuid
    $mboxObject.IsShared = $mailbox.IsShared
    $mboxObject.SamAccountName = $mailbox.SamAccountName
    $mboxObject.ServerName = $mailbox.ServerName
    $mboxObject.Office = $mailbox.Office
    $mboxObject.UserPrincipalName = $mailbox.UserPrincipalName
    $mboxObject.MailboxPlan = $mailbox.MailboxPlan
    $mboxObject.ArchiveStatus = $mailbox.ArchiveStatus
    $mboxObject.ArchiveState = $mailbox.ArchiveState
    $mboxObject.RemoteRecipientType = $mailbox.RemoteRecipientType
    $mboxObject.SKUAssigned = $mailbox.SKUAssigned
    $mboxObject.IsInactiveMailbox = $mailbox.IsInactiveMailbox
    $mboxObject.IsDirSynced = $mailbox.IsDirSynced
    $mboxObject.AccountDisabled = $mailbox.AccountDisabled
    $mboxObject.Alias = $mailbox.Alias
    $mboxObject.DisplayName = $mailbox.DisplayName
    $mboxObject.RecipientTypeDetails = $mailbox.RecipientTypeDetails
    $mboxObject.Identity = $mailbox.Identity
    $mboxObject.Name = $mailbox.Name
    $mboxObject.WhenCreated = $mailbox.WhenCreated
    $mboxObject.lastlogontime = $mboxStats.lastlogontime
    $mboxObject.ClutterEnabled = $mboxStats.IsClutterEnabled
    $mboxObject.TotalItemSize = $mboxStats.TotalItemSize
    $mboxObject.TotalDeletedItemSize = $mboxStats.TotalDeletedItemSize
    $mboxObject.ItemCount = $mboxStats.ItemCount
    $mailboxUsers += New-Object -TypeName PSObject -Property $mboxObject
}

$mailboxUsers | Export-Csv -NoTypeInformation C:\exploit\tosharepoint\MailboxUsers.csv
#>
$accountSkus  | Export-Csv -NoTypeInformation C:\exploit\tosharepoint\AccountSKUs.csv
$userList | Export-Csv -NoTypeInformation C:\exploit\tosharepoint\MsolUsers.csv
$licensedUsers | Export-Csv -NoTypeInformation C:\exploit\tosharepoint\LicensedAccounts.csv
$servicePlans | Export-Csv -NoTypeInformation C:\exploit\tosharepoint\ServicePlans.csv
$adminRoles | Export-Csv -NoTypeInformation C:\exploit\tosharepoint\AdminRoles.csv