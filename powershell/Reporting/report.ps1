$ScriptPath = Split-Path -Path $MyInvocation.MyCommand.Path
[xml]$ConfigFile = Get-Content (Join-Path $ScriptPath -ChildPath "settings.xml")

$global:templateLogo = 

#Import Global variables
. (Join-Path $ScriptPath -ChildPath "GlobalVariables.ps1")

[string]$body = (Get-Content (Join-Path $ScriptPath -ChildPath "template.html"))




$adminTable = @()


$MsolAdminUsers = @()

(Get-MsolRole) | foreach-object {
	$MsolRoleName = $_.name
	
	$MsolAdmin = Get-MsolRoleMember -RoleObjectId $_.ObjectId | select DisplayName, EmailAddress, IsLicensed, RoleMemberType, @{name="StrongAuthentication";expression={$_.StrongAuthenticationRequirements.State}}, @{name="Role";expression={$MsolRoleName}}
    $MsolAdminUsers += $MsolAdmin
}
break

[hashtable]$placeHolderTable = @{
    "miscLogo"             = [string]::Format("<img src='{0}' />",(Split-Path -Path C:\exploit\wang.txt -Leaf))
    "sensorNAME"           = "this is a test"
    "adminTABLE"           = $adminTable

}

$body = ($body -replace "sensorNAME", $placeHolderTable.sensorName)
$body = ($body -replace "adminTABLE", $placeHolderTable.adminTable)

Send-MailMessage @smtpsettings -Subject $subject -body ($body) -BodyAsHtml