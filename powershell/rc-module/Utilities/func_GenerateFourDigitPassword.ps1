

Function Generate-FourDigitPassword {
<#
.SYNOPSIS
    Generates a random four digit Pin

.DESCRIPTION
    This script will generate a random four digit Pin which can be used for iPhone passwords or ATM machines

.EXAMPLE
    PS C:\> Generate-FourDigitPassword 
    2568

.EXAMPLE
    PS C:\> 1..5 | % {Generate-FourDigitPassword}
    5436
    1582
    6944
    8687
    9882


.NOTES

    Brett Reasor
    brett.reasor@remyusa.com
#>
    $result = -join(1..4 | ForEach-Object {Get-Random -Minimum 0 -Maximum 10})
    return $result
}