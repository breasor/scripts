#requires -version 5.0


[CmdletBinding()]
param ()

$gitUser = "Brett Reasor"
$gitEmail = "brett.reasor@gmail.com"

$Modules = @(
                "Posh-SSH"
                "PowerCLI"
                "Posh-Git"

            )

$Services = @(      "diagnosticshub.standardcollector.service" # Microsoft (R) Diagnostics Hub Standard Collector Service
                    "DiagTrack"                                # Diagnostics Tracking Service
                    "dmwappushservice"                         # WAP Push Message Routing Service (see known issues)
                    "HomeGroupListener"                        # HomeGroup Listener
                    "HomeGroupProvider"                        # HomeGroup Provider
                    "lfsvc"                                    # Geolocation Service
                    "MapsBroker"                               # Downloaded Maps Manager
                    "NetTcpPortSharing"                        # Net.Tcp Port Sharing Service
                    #"RemoteAccess"                             # Routing and Remote Access
                    #"RemoteRegistry"                           # Remote Registry
                    "SharedAccess"                             # Internet Connection Sharing (ICS)
                    "TrkWks"                                   # Distributed Link Tracking Client
                    "WbioSrvc"                                 # Windows Biometric Service
                    #"WlanSvc"                                 # WLAN AutoConfig
                    "WMPNetworkSvc"                            # Windows Media Player Network Sharing Service
                    #"wscsvc"                                   # Windows Security Center Service
                    #"WSearch"                                 # Windows Search
                    "XblAuthManager"                           # Xbox Live Auth Manager
                    "XblGameSave"                              # Xbox Live Game Save Service
                    "XboxNetApiSvc"                            # Xbox Live Networking Service
            )

$CustomerExperiencetasks = @(   "Microsoft Compatibility Appraiser"
                                "ProgramDataUpdater"
                                "Consolidator"
                                "KernelCeipTask"
                                "UsbCeip"
                            )

$Windows10AppXPackages = @(
                             # default Windows 10 apps
                             "Microsoft.3DBuilder"
                             "Microsoft.Appconnector"
                             "Microsoft.BingFinance"
                             "Microsoft.BingNews"
                             "Microsoft.BingSports"
                             "Microsoft.BingWeather"
                             #"Microsoft.FreshPaint"
                             "Microsoft.Getstarted"
                             "Microsoft.MicrosoftOfficeHub"
                             "Microsoft.MicrosoftSolitaireCollection"
                             #"Microsoft.MicrosoftStickyNotes"
                             "Microsoft.Office.OneNote"
                             #"Microsoft.OneConnect"
                             "Microsoft.People"
                             "Microsoft.SkypeApp"
                             #"Microsoft.Windows.Photos"
                             #"Microsoft.WindowsAlarms"
                             "Microsoft.WindowsCalculator"
                             #"Microsoft.WindowsCamera"
                             "Microsoft.WindowsMaps"
                             "Microsoft.WindowsPhone"
                             #"Microsoft.WindowsSoundRecorder"
                             #"Microsoft.WindowsStore"
                             "Microsoft.XboxApp"
                             "Microsoft.ZuneMusic"
                             "Microsoft.ZuneVideo"
                             "microsoft.windowscommunicationsapps"
                             "Microsoft.MinecraftUWP"

                             # Threshold 2 apps
                             "Microsoft.CommsPhone"
                             "Microsoft.ConnectivityStore"
                             "Microsoft.Messaging"
                             #"Microsoft.Office.Sway"
                             "Microsoft.OneConnect"
                             "Microsoft.WindowsFeedbackHub"
                             
                             #Redstone apps
                             "Microsoft.BingFoodAndDrink"
                             "Microsoft.BingTravel"
                             "Microsoft.BingHealthAndFitness"
                             "Microsoft.WindowsReadingList"
                             
                             # non-Microsoft
                             "9E2F88E3.Twitter"
                             "PandoraMediaInc.29680B314EFC2"
                             "Flipboard.Flipboard"
                             "ShazamEntertainmentLtd.Shazam"
                             "king.com.CandyCrushSaga"
                             "king.com.CandyCrushSodaSaga"
                             "king.com.*"
                             "ClearChannelRadioDigital.iHeartRadio"
                             "4DF9E0F8.Netflix"
                             "6Wunderkinder.Wunderlist"
                             "Drawboard.DrawboardPDF"
                             "2FE3CB00.PicsArt-PhotoStudio"
                             "D52A8D61.FarmVille2CountryEscape"
                             "TuneIn.TuneInRadio"
                             "GAMELOFTSA.Asphalt8Airborne"
                             #"TheNewYorkTimes.NYTCrossword"
                             "DB6EA5DB.CyberLinkMediaSuiteEssentials"
                             "Facebook.Facebook"
                             "flaregamesGmbH.RoyalRevolt2"
                             "Playtika.CaesarsSlotsFreeCasino"

                             # apps which cannot be removed using Remove-AppxPackage
                             #"Microsoft.BioEnrollment"
                             #"Microsoft.MicrosoftEdge"
                             #"Microsoft.Windows.Cortana"
                             #"Microsoft.WindowsFeedback"
                             #"Microsoft.XboxGameCallableUI"
                             #"Microsoft.XboxIdentityProvider"
                             #"Windows.ContactSupport"
                             )

$ChocolatelySoftware = @(   "googlechrome"
                            "firefox"
                            "git.install"
                            "visualstudiocode"
                            "fiddler4"
                            "tightvnc"
                            "sharex"
                            "7zip.install"
                            "filezilla"
                            "atom"
                            "putty.install"
                            "winscp.install"
                            "terminals"
                            "irfanview"
                            "irfanviewplugins"
                            "sumatrapdf"
                            "googledrive"
                            "lastpass"
                            "sysinternals"
                            "awstools.powershell"
                            "terminals"
                        )

$thisscript = $MyInvocation.MyCommand.Definition


$ErrorActionPreference = 'Stop';

$IsAdmin = (New-Object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $IsAdmin) {
    Start-Process -FilePath powershell $thisscript -Verb runas; "Launching {0} as Administrator" -f $thisscript
    break
}


Write-Verbose "Setting exeuction policy"
Set-ExecutionPolicy RemoteSigned

Write-Verbose "Cleanup Privacy"
Write-Verbose "Removing Preinstalled Applications Packages"
#foreach ($app in $Windows10AppXPackages) { Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue }
# To add back an application use the following : Add-AppxPackage -DisableDevelopmentMode -Register "$($(Get-AppXPackage -AllUsers "Microsoft.WindowsAlarms").InstallLocation)\AppXManifest.xml"
Write-Verbose "Disabling User Experience Services"
foreach ($service in $Services) { Set-Service $Service -StartupType Disabled -ErrorAction SilentlyContinue }
Write-Verbose "Disabling User Experience Tasks"
foreach ($task in $CustomerExperiencetasks) { Disable-ScheduledTask (Get-ScheduledTask $task) }
Write-Verbose "Disabling Remaining Telemetry"
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name AllowTelemetry -Value "1" -Force
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name DODownloadMode -Value "0" -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Value "0" -Force


Write-Verbose "Setting folder view options"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideDrivesWithNoMedia" -Value 0

if (-not (Get-WmiObject -Class Win32_OperatingSystem).caption -like "*server*") {
Write-Verbose "Installing Linux Subsystem..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowAllTrustedApps" -Type DWord -Value 1
#Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
}
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x9e,0x1e, 0x06, 0x80, 0x12, 0x00, 0x00, 0x00))

Write-Verbose "Ensuring PS profile exists"
if (-not (Test-Path $PROFILE)) {
    New-Item $PROFILE -Force
}

# Start-Process 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe' -Credential (Get-SecureCredentials groupe-rc\a-breasor)
# $cmdApp = "$env:windir\system32\cmd.exe"
# $mmcArgs =  "/c $env:windir\system32\mmc.exe C:\exploit\local\admin.msc"
# Start-Process $cmdApp $mmcAppArgs -Credential (Get-SecureCredentials groupe-rc\a-breasor)
# Start-Process "$env:windir\system32\WindowsPowerShell\v1.0\Powershell.exe" (Get-SecureCredentials groupe-rc\a-breasor)


Write-Verbose "Ensuring Chocolatey is available"
Get-PackageProvider -Name chocolatey -ErrorAction SilentlyContinue -Force
if ($?) {
    Write-Verbose "Ensuring Chocolately is trusted"
    if (-not ((Get-PackageSource -Name chocolatey).IsTrusted)) {
        Set-PackageSource -Name chocolatey -Trusted
    }
    ForEach ($package in $ChocolatelySoftware) { 
        Install-Package -Name $package -ErrorAction SilentlyContinue
        if (-not $?) { Write-Warning "Error installing $package" } }
}


Write-Verbose "Configuring git"
Write-Verbose "Setting git user.name to $gitUser"
git config --global user.name $gitUser
Write-Verbose "Setting git user.email to $gitEmail"
git config --global user.email $gitEmail
Write-Verbose "Setting git defaults"
git config --global push.default simple
git config --global core.autocrlf true
Write-Verbose "Setting git aliases"
git config --global alias.st "status"
git config --global alias.co "checkout"
git config --global alias.df "diff"
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"


Write-Verbose "Creating God Mode Folder"
$DesktopPath = [Environment]::GetFolderPath("Desktop")
New-Item -ItemType Directory "$DesktopPath\God Mode.{ED7BA470-8E54-465E-825C-99712043E01C}" -Force

<#
break



Write-Progress -Activity "Enabling Office smileys"
if (Test-Path HKCU:\Software\Microsoft\Office\16.0) {
    if (-not (Test-Path HKCU:\Software\Microsoft\Office\16.0\Common\Feedback)) {
        New-Item HKCU:\Software\Microsoft\Office\16.0\Common\Feedback -ItemType Directory
    }
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Office\16.0\Common\Feedback -Name Enabled -Value 1
}
else {
    Write-Warning "Couldn't find a compatible install of Office"
}

#>
Write-Progress "Enabling PowerShell on Win+X"
if ((Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\).DontUsePowerShellOnWinX -ne 0) {
    Set-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ -Name DontUsePowerShellOnWinX -Value 0
    Get-Process explorer | Stop-Process
}
<#
Write-Progress -Activity "Setting PS aliases"
if ((Get-Alias -Name st -ErrorAction SilentlyContinue) -eq $null) {
    Add-Content $PROFILE "`r`n`r`nSet-Alias -Name st -Value (Join-Path `$env:ProgramFiles 'Sublime Text 3\sublime_text.exe')"
}
#>
Write-Progress -Activity "Reloading PS profile"
. $PROFILE

Write-Verbose "Downloading and installing Components to Manage Exchange Online with Powershell"
$MsolURI = "http://download.microsoft.com/download/5/0/1/5017D39B-8E29-48C8-91A8-8D0E4968E6D4/en/msoidcli_64.msi"
$AdminConfigURI = "https://bposast.vo.msecnd.net/MSOPMW/Current/amd64/AdministrationConfig-en.msi"
Start-BitsTransfer -Source $MsolURI -Description "Microsoft Online services" -Destination $env:temp -DisplayName "Microsoft Online Services"
Start-BitsTransfer -Source $AdminConfigURI -Description "Microsoft Azure Active Directory Powershell Module" -Destination $env:temp -DisplayName "Microsoft Azure Active Directory Powershell Module"
Start-Process -FilePath msiexec.exe -ArgumentList "/i $env:temp\$(Split-Path $MsolUri -Leaf) /quiet /passive"
Start-Process -FilePath msiexec.exe -ArgumentList "/i $env:temp\$(Split-Path $AdminConfigURI -Leaf) /quiet /passive"

Write-Verbose "Downloading and installing Chrome"
$ChromeURI = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
Start-BitsTransfer -Source $ChromeURI -Description "Chrome StandAlone Installer" -Destination $env:temp -DisplayName "Chrome StandAlone Installer" 
Start-Process -FilePath msiexec.exe -ArgumentList "/i $env:temp\$(Split-Path $ChromeURI -Leaf) /quiet /passive"