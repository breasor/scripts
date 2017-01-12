function Get-Uptime { 
 $os = Get-WmiObject win32_operatingsystem
 $uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
 $Display = "" + $Uptime.Days + " days / " + $Uptime.Hours + " hours / " + $Uptime.Minutes + " minutes"
 return $Display
}