<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.93
	 Created on:   	9/14/2015 2:04 PM
	 Created by:   	breasor
	 Organization: 	Remy Cointreau USA
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
[xml]$config = Get-Content c:\ESSBASE\Gen5\config\CloseCalendar.xml
$atemp = @()
foreach ($entry in $config.Calendar.Entry)
{
	if ($entry.Depletion) { $depl = $entry.Depletion.substring(0, 4) + "-" + $entry.Depletion.substring(4, 2) + "-" + $entry.Depletion.substring(6, 2) } else { $depl = ""}
	if ($entry.SCO) { $sco = $entry.SCO.substring(0, 4) + "-" + $entry.SCO.substring(4, 2) + "-" + $entry.SCO.substring(6, 2) } else { $sco = "" }
	if ($entry.SCOTrup)  { $scotrup = $entry.SCOTrup.substring(0, 4) + "-" + $entry.SCOTrup.substring(4, 2) + "-" + $entry.SCOTrup.substring(6, 2) } else { $scotrup = ""}
	if ($entry.SCostTrup)  { $scostrup = $entry.SCostTrup.substring(0, 4) + "-" + $entry.SCostTrup.substring(4, 2) + "-" + $entry.SCostTrup.substring(6, 2) } else { $scostrup = ""}
	$temp = New-Object System.Management.Automation.PSObject -Property @{
		Year = $entry.Year
		Month = $entry.curMonth
		Depletion = $depl
		SCO = $sco
		SCOTrup = $scotrup
		ScostTrup = $scostrup
	}
	
	$atemp += $temp
}

$atemp | select Year, Month, Depletion, SCO, SCOTrup, SCostTrup | Export-Csv c:\ESSBASE\cal2.csv

