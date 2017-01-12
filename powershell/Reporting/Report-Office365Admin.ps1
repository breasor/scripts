
#Load Settings File
$ScriptPath = Split-Path -Path $MyInvocation.MyCommand.Path
[xml]$ConfigFile = Get-Content (Join-Path $ScriptPath -ChildPath "settings.xml")

#Import Style
. (Join-Path $ScriptPath -ChildPath "style.ps1")

#Import Global variables
. (Join-Path $ScriptPath -ChildPath "GlobalVariables.ps1")


Function Get-HTMLTable {
	param([array]$Content)
	$HTMLTable = $Content # | ConvertTo-Html -Fragment
	$HTMLTable = $HTMLTable -Replace '<TABLE>', '<TABLE><style>tr:nth-child(even) { background-color: #e5e5e5; TABLE-LAYOUT: Fixed; FONT-SIZE: 100%; WIDTH: 100%}</style>' 
	$HTMLTable = $HTMLTable -Replace '<td>', '<td style= "FONT-FAMILY: Tahoma; FONT-SIZE: 8pt;">'
	$HTMLTable = $HTMLTable -Replace '<th>', '<th style= "COLOR: #$($Colour1); FONT-FAMILY: Tahoma; FONT-SIZE: 8pt;">'
	$HTMLTable = $HTMLTable -replace '&lt;', "<"
	$HTMLTable = $HTMLTable -replace '&gt;', ">"
	Return $HTMLTable
}

$smtpSettings = @{
    To = $ConfigFile.Settings.EmailSettings.MailTo
    From = $ConfigFile.Settings.EmailSettings.MailFrom
    SmtpServer = $ConfigFile.Settings.EmailSettings.SMTPServer
    }

$roleTypes = $ConfigFile.Settings.RoleSettings.Roles.value






#$body = $HTMLTemplate 
$body = ""
ForEach ($role in (Get-MsolRole)) {
    #(Get-MsolRoleMember -RoleObjectId (Get-MsolRole -RoleName $role)).count
    $body += "<h2>$role - $((Get-MsolRoleMember -RoleObjectId (Get-MsolRole -RoleName $role).objectid).count)</h2>" 
    $body += (Get-MsolRoleMember -RoleObjectId (Get-MsolRole -RoleName $role).objectid | select DisplayName, EmailAddress, IsLicensed, RoleMemberType, @{name="StrongAuthentication";expression={$_.StrongAuthenticationRequirements.State}}) | ConvertTo-Html -Fragment
}

$body += $HTMLEnd
$body = Get-HTMLTable $body

$body
$subject = "Office 365 Admin Report"

Send-MailMessage @smtpsettings -Subject $subject -body ($body) -BodyAsHtml