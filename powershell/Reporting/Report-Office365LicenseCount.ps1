

# Report HTML structure
$ReportHTML = @"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <title>_HEADER_</title>
      <meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
      <style type='text/css'>
         table	{
            width: 100%;
            margin: 0px;
            padding: 0px;
         }
         tr:nth-child(even) { 
            background-color: #e5e5e5; 
         }
         td {
               vertical-align: top; 
               font-family: Tahoma, sans-serif;
               font-size: 8pt;
               padding: 0px;
         }
         th {
               vertical-align: top;  
               color: #018AC0; 
               text-align: left;
               font-family: Tahoma, sans-serif;
               font-size: 8pt;
         }
         .pluginContent td { padding: 5px; }
         .warning { background: #FFFBAA !important }
         .critical { background: #FFDDDD !important }
      </style>
   </head>
   <body style="padding: 0 10px; margin: 0px; font-family:Arial, Helvetica, sans-serif; ">
      <a name="top" />
        <table width='100%' style='background-color: #0A77BA; border-collapse: collapse; border: 0px; margin: 0; padding: 0;'>
         <tr>
            <td>
               <img src='cid:Header-vCheck' alt='vCheck' />
            </td>
            <td style='width: 171px'>
               <img src='cid:Header-VMware' alt='VMware' />
            </td>
         </tr>
      </table>
      <div style='height: 10px; font-size: 10px;'>&nbsp;</div>
      <table width='100%'><tr><td style='background-color: #0A77BA; border: 1px solid #0A77BA; vertical-align: middle; height: 30px; text-indent: 10px; font-family: Tahoma, sans-serif; font-weight: bold; font-size: 8pt; color: #FFFFFF;'>_HEADER_</td></tr></table>
      <div>_TOC_</div>
      _CONTENT_
   <!-- CustomHTMLClose -->
   <div style='height: 10px; font-size: 10px;'>&nbsp;</div>
   
   </body>
</html>
"@
$xmlDir = "C:\GoogleDrive\Scripts\reports\xml\office365"
$licenseCount = 1900

$HTMLTemplate=@"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html><head><title>My Systems Report</title>
<style type="text/css">
<!--
body {
font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
}

    #report { width: 835px; }

    table{
       border-collapse: collapse;
       border: none;
       font: 10pt Verdana, Geneva, Arial, Helvetica, sans-serif;
       color: black;
       margin-bottom: 10px;
}
    table th {
       font-size: 12px;
		font:  Verdana, Geneva, Arial, Helvetica, sans-serif;
		font-weight: bold
       padding-left: 0px;
       padding-right: 20px;
       text-align: left;
}
    table td{
       font-size: 12px;
       padding-left: 0px;
       padding-right: 20px;
       text-align: left;
}



h2{ clear: both; font-size: 130%; }

h3{
       clear: both;
       font-size: 115%;
       margin-left: 20px;
       margin-top: 30px;
}

p{ margin-left: 20px; font-size: 12px; }

table.list{ float: left; }

    table.list td:nth-child(1){
       font-weight: bold;
       border-right: 1px grey solid;
       text-align: right;
}

table.list td:nth-child(2){ padding-left: 7px; }
table tr:nth-child(even) td:nth-child(even){ background: #CCCCCC; }
table tr:nth-child(odd) td:nth-child(odd){ background: #F2F2F2; }
table tr:nth-child(even) td:nth-child(odd){ background: #DDDDDD; }
table tr:nth-child(odd) td:nth-child(even){ background: #E5E5E5; }
div.column { width: 320px; float: left; }
div.first{ padding-right: 20px; border-right: 1px  grey solid; }
div.second{ margin-left: 30px; }
table{ margin-left: 20px; }
-->
</style>
</head>
<body>
"@

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

    write-output "getting sources"

#$mailboxes = Import-Clixml (Join-Path $xmlDir -ChildPath "mailboxes.xml")
#$msolusers = Import-Clixml (Join-Path $xmlDir -ChildPath "msoluser.xml")
#$mboxstats = Import-Clixml (Join-Path $xmlDir -ChildPath "statistics.xml")
#$userMailboxes = $mailboxes | Where-Object {$_.RecipientTypeDetails -eq "usermailbox"}

write-output "done getting sources"

$roleTypes = @(  "Company Administrator" ; "User Account Administrator" ; "Service Support Administrator" )

ForEach ($role in $roleTypes) {
    $MsolAdmins = @(Get-MsolRoleMember -RoleObjectId (Get-MsolRole -RoleName $role).objectid | select DisplayName, EmailAddress, IsLicensed, RoleMemberType, @{name="StrongAuthenticationEnabled";expression={$_.StrongAuthenticationRequirements.State}}, @{name="Role";e={$role}})
}


Get-MsolAccountSku | Where {$_.ConsumedUnits -ge 1}  |  Select @{name="Sku";expression={$Sku.item($_.SkuPartNumber)}}, ActiveUnits, ConsumedUnits, @{name="FreeUnits";expression={($_.ActiveUnits - $_.ConsumedUnits)}} | Sort-Object Sku

#$mailboxes = Get-MailboxByDomain "remyusa.com" | select Userprincipalname
#$licensedUsers =  @(Get-MsolUser -all -EnabledFilter EnabledOnly -DomainName "collectif1806.com")
#$licensedUsers = $msolusers | Where-Object {$_.islicensed -eq $true}

#Write-Output "Number of Free Licenses (over $($licenseCount)) : $($licenseCount - $licensedUsers.count)"
#Write-Output "Mailboxes not accessed for over 3 months : $()"

#$licensedMailboxes = @()
#$inactiveMailboxes = @()
<#$userObjects = @()
foreach ($mailbox in $usermailboxes) {
    
        $UserStats = ($mboxstats | Where-Object {$_.MailboxGuid -eq $mailbox.ExchangeGuid})
		$MsolUser = ($msolusers | Where-Object {$_.UserPrincipalName -eq $mailbox.UserPrincipalName})
		$licenseSKU = $msoluser.Licenses.AccountSKUId | Where-Object {$_ -like "*:STANDARDPACK" -or $_ -like "*:ENTERPRISEPACK"}
		#CountryOrRegion, office, StateOrProvince, phone, Mobilephone, title
		
		$UserObject = [pscustomobject][ordered]@{
			DisplayName = $mailbox.DisplayName
			Mboxtype = $Mailbox.RecipientTypeDetails
			UPN = $MsolUser.UserPrincipalname
			Company = $MsolUser.company
			Office = $MsolUser.Office
			City = $MsolUser.City
			UsageLocation = $MsolUser.UsageLocation
			LastLogon = $UserStats.LastLogonTime
			LicenseSKU = $LicenseSKU
			IsDisabled = $MsolUser.BlockCredential
		}
    $UserObjects += $UserObject
    
    }
  #>

  #$disabledUsers = (Get-ADUser -Filter * -SearchBase "OU=@disabled, OU=Users, OU=NYC0, OU=US, OU=NA, DC=groupe, DC=remy, DC=cointreau")
#$Users = (Get-ADUser -Filter { Enabled -eq $false } -Properties *)
#$Users = (Get-MsolUser -All | where {($_.IsLicensed -eq $true) -and ($_.UserPrincipalname -like "*remyusa.com")})
#$Users = (Get-MsolUser -All | where { ($_.IsLicensed -eq $true) })
#$Users = (Get-MsolUser -UserPrincipalName X-ST-ARCHE@remy-cointreau.com)
$Users = (Get-MsolUser -UserPrincipalName brett.reasor@remyusa.com )
#$Users = (Get-MsolUser -UserPrincipalName edith.cai@remyasia.com)
  
  get-mailbox brett.reasor@remyusa.com |
    select Displayname, OrganizationalUnit, Database, RetentionPolicy,
        @{n="MailboxSizeMB";
            e = {$MBXstat = Get-MailboxStatistics $_.Displayname; $MBXstat.TotalItemSize}},
        @{n="Department";
            e = {$ea = $_.primarysmtpaddress.tostring();
                $dept = Get-aduser -filter {emailaddress -eq $ea} -properties department;
                $dept.Department}},
        @{n="Title";
            e = {$ea = $_.primarysmtpaddress.tostring();
                $title = Get-aduser -filter {emailaddress -eq $ea} -properties Title; $title.Title}}
             
<#
Office365 licences
Number of free licences (over 1900) : -97
Mailboxes not accessed for 3 months : 86
Accounts locked : 45
Accounts never used : 36
Active mailboxes : 1875
Shared mailbox with licence : 9
Accounts with licence but without mailbox : 7

Office365 Administrators

Number of Global Administrator : 17
Number of Exchange Administrator : 19
Number of Sharepoint Administrator : 7
#>