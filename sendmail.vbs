' Create Date: 04/18/2011
' Arguments
'   1  From email address
'   2  List of To Email addresses
'   3  Subject
'   4  Messgae Body
'   5 ... n Attachemnts
'
'Example
'   Sendmail.vbs "essbase-dev@remyusa.com" "harold.sun@remyusa.com" "Subject" "Message" "Attachment1" "Attachment2" ..."Attachmentn" 
'
'

dim objMessage

dim strFm
dim strTo
dim strSubject
dim strMessage
dim strAttachemnt

Set ArgObj = WScript.Arguments 

if ArgObj.count < 4 Then
	msgbox "Can't Sendmail: Minimum 4 arguments are required"
else
	strFm		= ArgObj(0) 
	strTo		= ArgObj(1)
	strSubject	= ArgObj(2)
	strMessage	= ArgObj(3)

	Set objMessage = CreateObject("CDO.Message") 
	objMessage.Subject = strSubject	
	objMessage.From = strFm		
	objMessage.To = strTo		
	objMessage.TextBody = strMessage	
	
	if ArgObj.count > 4 then 
		For i = 4 to ArgObj.count -1
			objMessage.AddAttachment ArgObj(i)
		Next
	end if

	'==This section provides the configuration information for the remote SMTP server.
	'==Normally you will only change the server name or IP.
	objMessage.Configuration.Fields.Item _
	("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 
	
	'Name or IP of Remote SMTP Server
	objMessage.Configuration.Fields.Item _
	("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.remyusa.com"
	'==("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "10.90.0.154"

	'Server port (typically 25)
	objMessage.Configuration.Fields.Item _
	("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 
	
	objMessage.Configuration.Fields.Update
	
	'==End remote SMTP server configuration section==
	
	objMessage.Send
	

end if

