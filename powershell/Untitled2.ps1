#Get-Recipient -Filter 'RecipientTypeDetails -eq ''MailNonUniversalGroup,MailUniversalDistributionGroup,MailUniversalSecurityGroup,DynamicDistributionGroup''' -Properties 'Identity,DisplayName,RecipientTypeDetails,PrimarySmtpAddress' -ResultSize 500 
#get-distributiongroup "US-Information Technology" | fl
#get-distributiongroup | select DisplayName, Alias, samaccountname, PrimarySmtpAddress | export-csv c:\scripts\reports\dgreport.csv -NoTypeInformation

#get-distributiongroup -resultsize unlimited |? {!(get-distributiongroupmember $_.alias)}
#set-distributiongroup     NEW-YORK_MEETING_ROOM          -managedby "a-breasor@remyusa.com" -BypassSecurityGroupManagerCheck
#get-distributiongroup -resultsize unlimited | get-distributiongroupmember $_.alias | select alias, count

#$dgs | foreach { $count = (get-distributiongroupmember $_.alias).count; write-host $_.alias $_.mail $count} 
#$dgs | ? {(get-distributiongroupmember $_.alias |-eq "alexandre.page-relo" ); write-host $_.alias } 
#set-distributiongroup     testjulien          -managedby "a-breasor@remyusa.com" -BypassSecurityGroupManagerCheck

$dgs = get-distributiongroup -resultsize unlimited
$dgs | select DisplayName, Alias, samaccountname, PrimarySmtpAddress | export-csv c:\scripts\reports\dgreport.csv -NoTypeInformation