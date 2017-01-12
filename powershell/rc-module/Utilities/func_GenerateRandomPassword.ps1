

function Generate-RandomPassword
{
<#

.SYNOPSIS
    Generate Random Password up to 128 characters

.DESCRIPTION
    This script will generate a random simple or complex password limited to 128 characters.  By default, a simple 12 character password will be generated. If you wish to generate a 512 key or larger, use a loop and join as shown in examples

.PARAMETER Length

    A whole integer from 1 to 128

.PARAMETER complex
    
    A Boolean option to determine complexity of password

.EXAMPLE
    Generate-RandomPassword -Complex $true -Length 20
    
    This example generates a complex password with length 20
    
    PS C:\> Generate-RandomPassword -Complex $true -Length 20
    &HZ[NWW#h_fcT8ftX/Al

.EXAMPLE
    1..5 | % {Generate-RandomPassword}

    This example creates a list of 5 random passwords

    PS C:\> 1..5 | % {Generate-RandomPassword}
    qEqmM43cCG9N
    MMWyHcX1ySR
    Yv2zTHzFE7c
    MAjMZWcmv7u
    V68vzYSrLt9e

.EXAMPLE
    $SecureHashKey = -join(1..4 | % {Generate-RandomPassword -Length 128})

    This example creates a 512 bit secure hash
    
    PS C:\> $SecureHashKey = -join(1..4 | % {Generate-RandomPassword -Length 128})
m8vehA4UNQJweRo6DcYiteKRIaqCsMVcjXbYfkoXxRekSrTVkbDxkLRVKMbTVM9TUp7JaibITZ1yqpKJbgezRnewP768BQWghfl56DlaMyw5Hdoui8yvFXkkYrSNOGe0jMi5vQUDlxBIcuSpgQoUufhNPW5ZCTsm2dAuOLHdJR
c9HefWrcATpMo5dliiGnzS2ienPHhkTW5VLykMTZ465uTsEUDWIpGbqGvtBumSPy4qv4gFNHi3Xe8dmkweafJaoB0BszkyvVnY1PxHebce7uErcpQ1Z0kSUhLvRfKpHTgXZ8d8eLSyziVYo0bUtVHDj1zwYLh7fCscrT3qI4If
KFw5SKMv54YrvRDtHdnfJ5uriiwlEsYTQi1brymXRnsXpQBEbCRusHWSSpnssXnjmYMViRUfZIdKzCrp8H4FMo6CeBeXdbhPucR7icsZwEqxTIAGQwbFO6fzeTvM0mFNowAYR4BR01Ds9fUvWfx2gWaGGWq


.NOTES

    Brett Reasor
    brett.reasor@remyusa.com
#>

       Param (
        [parameter()]
        [ValidateRange(1,128)]
        [Int]$Length = 12,
        [parameter()]
        [bool]$Complex = $false

    )
    Add-Type -AssemblyName System.Web
    $chars = "abcdefghijkmnopqrstuvwxyzABCEFGHJKLMNPQRSTUVWXYZ"
    [string]$pass_upper   = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    [string]$pass_lower   = 'abcdefghijklmnopqrstuvwxyz'
    [string]$pass_digits  = '0123456789'
    [string]$pass_special = '~!@#$%^&*_-+=`|\(){}[]:;"<>,.?/'
    
    do { $result = [System.Web.Security.Membership]::GeneratePassword($Length,1)
        } until ($result -match '\d')
    
    if (!$complex) {
        $Regex = '[^a-zA-Z0-9]'
        $simple = @()
        foreach ($str in $result.ToCharArray()) 
        {
            #$str = $str -replace $Regex, $chars[(get-random -Maximum 52)] 
            $simple += $str -replace $Regex, $chars[(get-random -Maximum 52)] 
        }
        
        $result = $simple -join ""
        <#
        do {
            $result = $result -replace ("[^a-zA-Z0-9]",$chars[(get-random -Maximum 52)])
        } until ($result -match "[a-zA-Z0-9]")
        #>
        
    }
    return $result
}
