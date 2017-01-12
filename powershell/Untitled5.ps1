#Get-Mailbox -RecipientTypeDetails RoomMailbox | select name, alias | ft -AutoSize

#Set-MailboxCalendarFolder -Identity remy-martin-newyorkcity:\calendar -PublishEnabled $true -DetailLevel limiteddetails
get-mailboxcalendarfolder -Identity brett.reasor:\calendar