function Start-PsElevatedSession{ 
<#
.SYNOPSIS
    Start an elevated session of powershell

.DESCRIPTION
    Start an elevated session of powershell.  Will open ISE if in ISE.

.EXAMPLE
    Start-PsElevatedSession
#>

    #Open a new elevated powershell window
    If( ! (Test-Administrator) ){
        if( $host.name -match 'ISE' ) { start-process PowerShell_ISE.exe -Verb runas }
        Else{ start-process -filepath "powershell $($MyInvocation.MyCommand.Definition)" -Verb runas -filepath  }
    }
    Else{ Write-Warning "Session is already elevated" }
} 


start-pselevatedsession