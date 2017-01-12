Download a copy to your computer (I place in c:\scripts\powershell)

Set execution policy to Unrestricted
	PS C:\> Set-ExecutionPolicy -ExecutionPolicy Unrestricted

If you don't have a profile, create one
if (-not (Test-Path $profile)) { New-item –type file –force $profile; notepad $profile} else {notepad $profile}

Add the following:

$LocalLibraries = "C:\scripts\powershell\rc-module\"
$env:PSModulePath = $env:PSModulePath + ";$LocalLibraries"

# Function to reload Module
Function int_ModuleNameModuleLoad {
    Import-Module $localLibraries\rc-module -Force -WarningAction SilentlyContinue
    Write-Host "Module-Name Reloaded"
}

# Set Aliases
If (-not(Get-Alias "reload" -ErrorAction SilentlyContinue)) {
    New-Alias -Name reload -Value int_ModuleNameModuleLoad -Force
}

reload


-- now you can do 

PS C:\scripts> Get-Command -Module rc-module -CommandType Function

CommandType     Name                                               Version    Source                                                                                                          
-----------     ----                                               -------    ------                                                                                                          
Function        Clear-ADGroupMemberShip                            0.0        rc-module                                                                                                       
Function        Clear-DGMemberShip                                 0.0        rc-module                                                                                                       
Function        Connect-ExchangeOnline                             0.0        rc-module                                                                                                       
Function        Disable-UserMailbox                                0.0        rc-module                                                                                                       
Function        Disconnect-ExchangeOnline                          0.0        rc-module                                                                                                       
Function        Find-EmptyGroups                                   0.0        rc-module                                                                                                       
Function        Generate-FourDigitPassword                         0.0        rc-module                                                                                                       
Function        Generate-RandomPassword                            0.0        rc-module                                                                                                       
Function        Get-DGMemberShip                                   0.0        rc-module                                                                                                       
Function        Get-MailboxByDomain                                0.0        rc-module                                                                                                       
Function        Get-ScriptDirectory                                0.0        rc-module                                                                                                       
Function        Get-SecureCredentials                              0.0        rc-module                                                                                                       
Function        Get-Uptime                                         0.0        rc-module                                                                                                       
Function        Remove-StringLatinCharacters                       0.0        rc-module                                                                                                       
Function        Remove-StringSpecialCharacter                      0.0        rc-module                                                                                                       
Function        Set-CalendarDelegate                               0.0        rc-module                                                                                                       
Function        Start-PsElevatedSession                            0.0        rc-module                                                                                                       
Function        Test-Administrator                                 0.0        rc-module                                                                                                       
Function        Validate-LoginName                                 0.0        rc-module                                                                                                       
Function        Validate-SPF                                       0.0        rc-module                                                                                                       
                                                                             
