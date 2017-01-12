$resolver = "8.8.8.8"

$domains = get-content C:\exploit\domains.csv
$output = @()
$domains | ForEach-Object {
            $record =  Remove-StringLatinCharacters $_
            $record
      
            $SPFRecord = (Resolve-DnsName -type TXT -Server $resolver -Name $record -ErrorAction silentlycontinue )
            $dmarcRecord = (Resolve-DnsName -type ANY -Server $resolver -Name ("_dmarc.$($record)") -ErrorAction silentlycontinue )
 
            $mxrecord = (Resolve-DnsName -type MX -Server $resolver -Name $record -ErrorAction silentlycontinue )
            $wwwrecord = (Resolve-DnsName -type ANY -Server $resolver -Name ("www.$($record)") -ErrorAction silentlycontinue )
            $rootrecord = (Resolve-DnsName -type A -Server $resolver -Name $record -ErrorAction silentlycontinue )
            
      
                   $outputObject = [pscustomobject][ordered]@{
			    domainName = $record
			    spfType = $SPFRecord.Type
                spfSTring = $SPFRecord.strings
			    dmarcType = $dmarcRecord.Type
                dmarcSTring = $dmarcRecord.strings
                dmarcHost = $dmarcRecord.NameHost
                mxrecords = $mxrecord.namehost
                wwwrecord = $wwwrecord.namehost
                rootrecord = ($rootrecord.ipaddress -join ";")
		    }
            $output += $outputObject
    }
    
    #^(?=.{1,255}$)[0-9A-Za-z](?:(?:[0-9A-Za-z]|-){0,61}[0-9A-Za-z])?(?:\.[0-9A-Za-z](?:(?:[0-9A-Za-z]|-){0,61}[0-9A-Za-z])?)*\.?$
#Resolve-DnsName -type TXT -Server $resolver -Name $record -ErrorAction Stop 