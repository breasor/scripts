function Get-MailboxByDomain
{
<#
.SYNOPSIS
   Get all mailboxes for a particular domain

.DESCRIPTION
   Find all mailboxes with a particular domain

.EXAMPLE
    Get-MailboxByDomain -DomainName contoso.com

    PS C:\scripts> Get-MailboxByDomain contoso.com

    Name                      Alias                ServerName       ProhibitSendQuota                                                                                                             
    ----                      -----                ----------       -----------------                                                                                                             
    Adrien SMITH              Adrien.SMITH         vi1pr0201mb1234  49.5 GB (53,150,220,288 bytes)                                                                                                
    Amy ELLIOTT               Amy.ELLIOTT          db5pr02mb1234    49.5 GB (53,150,220,288 bytes)                                                                                                
    Daniel BURDETTE           Daniel.BURDETTE      he1pr0201mb1234  49.5 GB (53,150,220,288 bytes)                                                                                                
    Duane FLOREZ              Duane.FLOREZ         am4pr02mb1234    45 GB (48,318,382,080 bytes)                                                                                                  
    Freddy KUTCH              Freddy.KUTCH         vi1pr0201mb1234  45 GB (48,318,382,080 bytes)                                                                                                  
    Justin RAE                Justin.RAE           db6pr0202mb1234  49.5 GB (53,150,220,288 bytes)                                                                                                                                                                                               
    Nathan PIMENTEL           Nathan.PIMENTEL      am5pr0202mb1234  49.5 GB (53,150,220,288 bytes)                                                                                                
    Franklin STERNA           Stilo.STERNA         amspr02mb124     49.5 GB (53,150,220,288 bytes)     
#>
	param (
		[Parameter(Mandatory = $true)]
		[string]$DomainName
	)
	
	Get-Mailbox -Filter "UserPrincipalName -like '*$($DomainName)'" -ResultSize Unlimited
}