

function Validate-SPF  {
<#
.SYNOPSIS
    Function to validate SPF record of domains
.DESCRIPTION
    Validates an SPF record of an email domain and returns result
.PARAMETER Domain
	Specifies the Domain that will be processed
.PARAMETER resolver
    Specifies the DNS resolver to perform the lookup
.EXAMPLE
    Validate-SPF -domain "google.com"
.EXAMPLE
    Validate-SPF -domain "google.com" -resolver "8.8.8.8"

#>
    [CmdletBinding()]
   param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [System.String[]]$domain,
    [ValidateScript({$_ -match [IPAddress]$_ })] 
    [string]$resolver = "8.8.8.8"
    )
    foreach ($record in $domain) {
        try {
            $SPFRecord = (Resolve-DnsName -type TXT -Server $resolver -Name $record -ErrorAction Stop )
            if ($SPFRecord) 
            {
                    Write-Output "SPF Record exists, checking validity of $($SPFRecord.strings)"  | timestamp
     
                    $fields = @{"domain" = $record; "serial" = "fred12" }
                    $spfResult = Invoke-WebRequest -uri "http://www.kitterman.com/getspf2.py " -Method Post -body $fields
                    $bodyText = ($spfResult.AllElements | ? {$_.tagname -eq "body"}).outertext -split "\n"
        
                    if ($bodyText -match "Permanant Error") {Write-Warning "$($bodyText -match "Error")"}
                    elseif ($bodyText -match "pass") {Write-Output "$($bodyText -match "pass")"}
            }
        }
        catch {
               Write-Warning -Message “Record not found for $record” | timestamp
            
        }

    }
}