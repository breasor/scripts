Function Validate-LoginName ($questionablestring) {
<#
.SYNOPSIS
  Validate login name  

.DESCRIPTION
    Checks a login name and make sure its acceptable for Active Directory username

.EXAMPLE
    Validate-LoginName
    
#>
    if ($questionablestring -match "[$([Regex]::Escape('/\[:;|=,+*?<>') + '\]' + '\"')]") { return $true }
    else { return $false }
}