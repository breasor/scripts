

function pwgen
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
        [ValidateRange(1,1024)]
        [Int]$Length = 12,
        [parameter()]
        [ValidateRange(1,100)]
        [Int]$NumPasswords = 5,
        [parameter()]
        [switch]$Complex = $false,
        [parameter()]
        [switch]$Ambiguous = $false,
        [parameter()]
        [switch]$NoDigits = $false,
        [parameter()]
        [switch]$NoVowels = $false

    )
    Add-Type -AssemblyName System.Web
    #$chars = "abcdefghijkmnopqrstuvwxyzABCEFGHJKLMNPQRSTUVWXYZ"
    [string]$pass_upper   = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    [string]$pass_lower   = 'abcdefghijklmnopqrstuvwxyz'
    [string]$pass_digits  = '0123456789'
    [string]$pass_special = '~!@#$%^&*_-+=`|\(){}[]:;"<>,.?/'
    [string]$pass_ambiguous = '5S1l0O'
    [string]$pass_vowels = 'aeiouAEIOU'
    [string]$chars = $pass_upper + $pass_lower + $pass_digits 
    


    Function Replace-Characters($string, $chars, $regex) {
        $regex = "^[$regex]"
        $newchars = @()
        Write-Verbose "Using regex $regex on $chars"
        foreach ($str in $chars.ToCharArray()) { $newchars += $str -replace $regex, "" }
        $chars = $newchars -join ""
        $simple = @()
        
        foreach ($str in $string.ToCharArray()) { $simple += $str -replace $Regex, $chars[(get-random -Maximum $chars.Length)] }
        $result = $simple -join ""
        Write-Verbose "New Password: $result" # and Regexp $regex"
        return $result, $chars
    }
    Function Generate-Password($chars) {
         if ($Length -gt 128) { $Length = 128 }
         do { $result = [System.Web.Security.Membership]::GeneratePassword($Length,1)
            } until ($result -match '\d')
        Write-Verbose "Unmodified Original Password: $result"
        
        if (!($complex)) {
            $Regex = '[^a-zA-Z0-9]'
            $simple = @()
            Write-Verbose "simplifiying"
            foreach ($str in $result.ToCharArray()) { $simple += $str -replace $Regex, $chars[(get-random -Maximum $chars.Length)] }
            $result = $simple -join ""
         }
         Write-Verbose "Generated Password Result: $result"
        return $result
    }
    
     [System.Text.StringBuilder]$passwordList = ''
    for ($j = 1; $j -le $NumPasswords; $j++) {
        
        if ($Length -le 128) { $result = Generate-Password $chars }
        elseif ($Length % 128 -eq 0) { $iterate = $Length/128 ; $result = -join (1..$iterate |  Generate-Password $chars) -join "" }
        else { break }


        if ($PSBoundParameters.ContainsKey('NoVowels')) {Write-Verbose "No Vowels"; $result, $chars = Replace-Characters $result $chars $pass_vowels }
        if ($PSBoundParameters.ContainsKey('NoDigits')) {Write-Verbose "No Digits"; $result, $chars = Replace-Characters $result $chars $pass_digits }
        if ($PSBoundParameters.ContainsKey('Ambiguous')) {Write-Verbose "No Ambiguous"; $result, $chars = Replace-Characters $result $chars $pass_ambiguous }
        

    Write-Verbose "Characters Used: $chars"
    
    

    $result
    #$result
            [void]$passwordList.AppendLine($result)
        
    }
break

    for ($j = 1; $j -le $NumPasswords; $j++) {
        do { $result = [System.Web.Security.Membership]::GeneratePassword($Length,1)
            } until ($result -match '\d')

        
        switch($PSBoundParameters.Keys)
        {
            
            {'NoVowels' } { $result = Replace-Characters $result $pass_vowels ; Write-Verbose "No Vowels" }
            { } { $result = Replace-Characters $result $pass_vowels+$pass_digits ; Write-Verbose "No Vowels, No Digits" }
        }
        
        <#    
        if (!$complex) {
            $Regex = '[^a-zA-Z0-9]'
            $simple = @()
            foreach ($str in $result.ToCharArray()) 
            {
                #$str = $str -replace $Regex, $chars[(get-random -Maximum 52)] 
                $simple += $str -replace $Regex, $chars[(get-random -Maximum $chars.Length)] 
            }
        
            $result = $simple -join ""           
            
        }
        if ($NoDigits) {
            $Regex = '[^a-zA-Z]'
            $simple = @()
            foreach ($str in $result.ToCharArray()) 
            {
                #$str = $str -replace $Regex, $chars[(get-random -Maximum 52)] 
                $simple += $str -replace $Regex, $chars[(get-random -Maximum $chars.Length)] 
            }
        
            $result = $simple -join ""           
            
        }
        if ($Ambiguous) {
            $Regex = '^[1l015S]'
            $simple = @()
            foreach ($str in $result.ToCharArray()) 
            {
                #$str = $str -replace $Regex, $chars[(get-random -Maximum 52)] 
                $simple += $str -replace $Regex, $chars[(get-random -Maximum $chars.Length)] 
            }
        
            $result = $simple -join ""           
            
        }
        if ($NoVowels) {
            $chars = "bcdfghjkmnpqrstvwxyzBCFGHJKLMNPQRSTVWXYZ"
            $Regex = '^[aeiouAEIOU]'
            $simple = @()
            foreach ($str in $result.ToCharArray()) 
            {
                #$str = $str -replace $Regex, $chars[(get-random -Maximum 42)] 
                $simple += $str -replace $Regex, $chars[(get-random -Maximum $chars.Length)] 
                
            }
        
            $result = $simple -join ""           
            
        }
        #>
        [void]$passwordList.AppendLine($result)
        
    }
    
    return $passwordList.ToString()
}
