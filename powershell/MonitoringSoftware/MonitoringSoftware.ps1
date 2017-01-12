Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

Configuration MonitoringSoftware
{
    param(
        [string[]]$ComputerName="usnyc0pas32"
    )
    Node $ComputerName
    {
        File MonitoringInstallationFiles
        {
            Ensure          = "Present"
            SourcePath      = "\\usnyc0pfs02\install\0tools"
            DestinationPath = "C:\exploit\tools"
            Type            = "Directory"
            Recurse         = $true
        }
    }
}  

MonitoringSoftware -ComputerName usnyc0l0890