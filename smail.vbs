' Create Date: 04/18/2011
' Updated: 08/05/2016 - brett.reasor@remyusa.com
' ' Now includes Error Handling and sending errors to text file
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


Const ForReading = 1, ForWriting = 2, ForAppending = 8
Const TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0

On Error Resume Next
oMailServer = "smtp.remyusa.com"
'oMailServer = "10.90.0.154"
outFile = "C:\Unix\Common\SendMail.err"

Set objFSO=CreateObject("Scripting.FileSystemObject")
If (objFSO.FileExists(outFile)) Then
  Set objFile = objFSO.OpenTextFile(outFile, ForAppending, True, TristateTrue)
Else
  Set objFile = objFSO.CreateTextFile(outFile, True)
  Set objFile = objFSO.OpenTextFile(outFile, ForWriting, True, TristateTrue)
End If

Function sendMail(strFrom, strTo, strSubject, strMail)
    Set objEmail = CreateObject("CDO.Message")
        objEmail.From = strFrom
        objEmail.To = strTo
        objEmail.Subject = strSubject
        objEmail.Textbody = strMail
        If strMailFile > 0 Then
          For i = 0 to strMailFile-1
            objEmail.AddAttachment Attachments(i)
          Next
        end if
    objEmail.Configuration.Fields.Item _
      ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    objEmail.Configuration.Fields.Item _
      ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = _
          oMailServer
    objEmail.Configuration.Fields.Item _
      ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") _
            = 25
    objEmail.Configuration.Fields.Update
    objEmail.Send

End Function

Set ArgObj = WScript.Arguments

if ArgObj.count < 4 then
  CreateObject("WScript.Shell").Popup "Can't Sendmail: Minimum 4 arguments are required", 30, "Error"
  wscript.quit()
else

  strFrom = ArgObj(0)
  strTo = ArgObj(1)
  strSubject = ArgObj(2)
  strMail = ArgObj(3)
end if
dim Attachments()
int strMailFile

if ArgObj.count > 4 then
  redim preserve Attachments(ArgObj.count - 4)
  for i = 4 to  ArgObj.count -1
    Attachments(i-4) = ArgObj(i)
  Next
  strMailFile = UBound(Attachments)
else
 strMailFile = 0
end if




sendMail strFrom, strTo, strSubject, strMail
If Err <> 0 Then
  CreateObject("WScript.Shell").Popup "There was an error sending the e-mail", 30, "Error"
  objFile.Write now() & " : " & Err.Description & vbCrLf
  wscript.quit()
End If
objFile.Close
