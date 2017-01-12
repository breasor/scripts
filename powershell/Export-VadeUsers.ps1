
Get-Mailbox -Filter "Userprincipalname -like '*@remyusa.com'" -ResultSize unlimited |  select @{name="first";e={($_.displayname -split " ")[0]}}, 
                                        @{name="last";expression={($_.displayname -split " ")[1]}}, 
                                        userprincipalname, 
                                        @{name="alias";expression={((($_.emailaddresses | Where-Object {($_ -cmatch "smtp") -and !($_ -cmatch "onmicrosoft.com")} ) -split ":") | Where-Object {$_ -ne "smtp" }) -join ";"}} | 
                      Export-Csv -NoTypeInformation -Delimiter ";" C:\exploit\vade-remyusa-com.txt



#Get-MsolUser -MaxResults 10 | ? {$_.UserPrincipalName -like "*@remyusa.com"} | select lastname, firstname, userprincipalname, @{n="alias";e={$_.proxyaddresses -join ";"}}