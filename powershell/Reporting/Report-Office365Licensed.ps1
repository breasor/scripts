
$Sku = @{ 
    "DESKLESSPACK" = "Office 365 (Plan K1)" 
    "DESKLESSWOFFPACK" = "Office 365 (Plan K2)" 
    "LITEPACK" = "Office 365 (Plan P1)" 
    "EXCHANGESTANDARD" = "Office 365 Exchange Online Only" 
    "STANDARDPACK" = "Enterprise Plan E1" 
    "STANDARDWOFFPACK" = "Office 365 (Plan E2)" 
    "ENTERPRISEPACK" = "Enterprise Plan E3" 
    "ENTERPRISEPACKLRG" = "Enterprise Plan E3" 
    "ENTERPRISEWITHSCAL" = "Enterprise Plan E4" 
    "STANDARDPACK_STUDENT" = "Office 365 (Plan A1) for Students" 
    "STANDARDWOFFPACKPACK_STUDENT" = "Office 365 (Plan A2) for Students" 
    "ENTERPRISEPACK_STUDENT" = "Office 365 (Plan A3) for Students" 
    "ENTERPRISEWITHSCAL_STUDENT" = "Office 365 (Plan A4) for Students" 
    "STANDARDPACK_FACULTY" = "Office 365 (Plan A1) for Faculty" 
    "STANDARDWOFFPACKPACK_FACULTY" = "Office 365 (Plan A2) for Faculty" 
    "ENTERPRISEPACK_FACULTY" = "Office 365 (Plan A3) for Faculty" 
    "ENTERPRISEWITHSCAL_FACULTY" = "Office 365 (Plan A4) for Faculty" 
    "ENTERPRISEPACK_B_PILOT" = "Office 365 (Enterprise Preview)" 
    "STANDARD_B_PILOT" = "Office 365 (Small Business Preview)" 
    "VISIOCLIENT" = "Visio Pro Online" 
    "POWERAPPS_INDIVIDUAL_USER" = "Power Apps"
    "POWER_BI_ADDON" = "Office 365 Power BI Addon" 
    "POWER_BI_INDIVIDUAL_USE" = "Power BI Individual User" 
    "POWER_BI_PRO" = "Power BI Pro"
    "POWER_BI_STANDALONE" = "Power BI Stand Alone" 
    "POWER_BI_STANDARD" = "Power BI standard" 
    "PROJECTESSENTIALS" = "Project Lite" 
    "PROJECTCLIENT" = "Project Professional" 
    "PROJECTONLINE_PLAN_1" = "Project Online" 
    "PROJECTONLINE_PLAN_2" = "Project Online and PRO" 
    "ECAL_SERVICES" = "ECAL" 
    "EMS" = "Enterprise Mobility Suite" 
    "RIGHTSMANAGEMENT_ADHOC" = "Windows Azure Rights Management" 
    "MCOMEETADV" = "PSTN conferencing" 
    "SHAREPOINTSTORAGE" = "SharePoint storage" 
    "PLANNERSTANDALONE" = "Planner Standalone" 
    "CRMIUR" = "CMRIUR" 
    "BI_AZURE_P1" = "Power BI Reporting and Analytics" 
    "INTUNE_A" = "Windows Intune Plan A" 
    } 




Get-MsolUser -All | 
    Where-Object  {$_.CloudExchangeRecipientDisplayType -ne "6"} |
    Select-Object userprincipalname, 
                  whencreated, 
                  isLicensed, 
                  BlockCredential, 
                  Department, 
                  Country, 
                  SignInName, 
                  State, 
                  Title, 
                  usagelocation, 
                  immutableid,
                  @{name="License";expression={($_.licenses.accountskuid) -join ";"}}, 
                  @{name="E1License";expression={[bool]($_.licenses.accountskuid -like "*STANDARDPACK")}},
                  @{name="E3License";expression={[bool]($_.licenses.accountskuid -like "*ENTERPRISEPACK")}},
                  @{name="PowerBILicense";expression={[bool]($_.licenses.accountskuid -like "*POWER_BI_PRO")}} |
    Export-Csv -NoTypeInformation C:\exploit\msoluserlist.csv
    

    Get-MsolUser -MaxResults 1 | 
    Where-Object  {$_.CloudExchangeRecipientDisplayType -ne "6" } |
    Select-Object userprincipalname, 
                  whencreated, 
                  isLicensed, 
                  BlockCredential, 
                  Department, 
                  Country, 
                  SignInName, 
                  State, 
                  Title, 
                  usagelocation, 
                  immutableid,
                  LastDirSyncTime,
                  licenses         |         
    ConvertTo-Json -Depth 6 | Out-File C:\exploit\jsonmsoluser.json

    
 Get-MsolAccountSku | 
    Where-Object {$_.ConsumedUnits -ge 1}  |  
    Select-Object skupartnumber,
           @{name="Sku";expression={$Sku.item($_.SkuPartNumber)}}, 
           ActiveUnits, 
           ConsumedUnits, 
           @{name="FreeUnits";expression={($_.ActiveUnits - $_.ConsumedUnits)}} | 
    Sort-Object Sku | 
    Export-Csv -NoTypeInformation C:\exploit\licensecount.csv



$AdminCSV = "C:\exploit\adminusers.csv"
if (Test-Path $AdminCSV) { Remove-Item $AdminCSV }
ForEach ($role in (Get-MsolRole)) {
    Get-MsolRoleMember -RoleObjectId $role.objectid | 
        Select-Object  DisplayName, 
                       EmailAddress, 
                       IsLicensed, 
                       RoleMemberType, 
                       @{name="StrongAuthentication";expression={$_.StrongAuthenticationRequirements.State}},
                       @{name="RoleName";expression={$role.Name}} |
        Export-Csv -NoTypeInformation -Append $AdminCSV
}

 Get-Mailbox -ResultSize unlimited | 
    Select-Object ExchangeGuid, 
                  IsShared, 
                  SamAccountName, 
                  ServerName, 
                  Office, 
                  UserPrincipalName, 
                  MailboxPlan,
                  ArchiveStatus, 
                  ArchiveState, 
                  RemoteRecipientType, 
                  SKUAssigned, 
                  IsInactiveMailbox, 
                  IsDirSynced, 
                  Alias, 
                  DisplayName, 
                  RecipientTypeDetails, 
                  Identity, 
                  Name, 
                  @{name="LastLogonTime"; Expression={[String]::join(";", (Get-MailboxStatistics -identity $_.identity).lastlogontime)}} | 
        Export-Csv -NoTypeInformation c:\exploit\mailboxusers.csv