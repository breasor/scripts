
[cmdletbinding()]
Param (
    [string]$from = "essbase@remyusa.com",
    [string]$to,
    [string]$subject,
    [string]$message,
    [string[]]$attachments)

begin {
#write-host $from $to $subject $message $attachments
    $server = "smtp.remyusa.com"
    
    $rcpt = $to -split " "
    $attachments = $attachments -split " "
    

}

process 
{

    Send-MailMessage -From $from -To $rcpt -Subject $subject -Body $message -SmtpServer $server -Attachments $attachments

}

end {

}

# 		${SENDMAIL} ${EMAIL_Sender_Err} ${EMAIL_Recipients} "${SUBJECT}" "${MAIL_DESC}"
# '   Sendmail.vbs "essbase-dev@remyusa.com" "harold.sun@remyusa.com" "Subject" "Message" "Attachment1" "Attachment2" ..."Attachmentn" 


#Send-MailMessage -from "brett.reasor@remyusa.com" -to "a-breasor@remyusa.com" -Subject "sending the attachment" -body "forgot" -Attachments "C:\Box Sync\desktop.ini" -SmtpServer smtp.remyusa.com