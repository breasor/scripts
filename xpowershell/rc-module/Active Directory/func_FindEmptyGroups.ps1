#Requires -Version 4 -Module ActiveDirectory

function Find-EmptyGroups  {
<#
.SYNOPSIS
    Function to find Active Directory Groups that are empty
.EXAMPLE
    Find-EmptyGroups

#>
    
    [CmdletBinding()]
   param(
    )
    begin { $ErrorActionPreference = 'Stop'
    }
    process {
		try
		{
			@(Get-ADGroup -Filter * -Properties isCriticalSystemObject,Members).where({ (-not $_.isCriticalSystemObject) -and ($_.Members.Count -eq 0) })
		}
		catch
		{
			$PSCmdlet.ThrowTerminatingError($_)
		}
    }
    end {}
}