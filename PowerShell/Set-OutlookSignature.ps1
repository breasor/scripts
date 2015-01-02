<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.47
	 Created on:   	4/13/2014 3:23 PM
	 Created by:   	breasor
	 Organization: 	Remy Cointreau USA
	 Filename:     	Set-OutlookSignature.ps1
	===========================================================================
	.DESCRIPTION
		Sets the Outlook Signature with variables pulled from Active Directory of the user
#>

begin
{
	$ForcedSignatureNew = 1
	$ForcedSignatureReplyForward = 1
	
	$banner = "https://s3.amazonaws.com/rcus_pr/Banners/RCUSA-Banner.gif"
	$Name = $env:username
}

process
{
	
	$Filter = "(&(objectCategory=User)(samAccountName=$Name))"
	
	$Searcher = New-Object System.DirectoryServices.DirectorySearcher
	$Searcher.Filter = $Filter
	
	$Path = $Searcher.FindOne()
	$User = $Path.GetDirectoryEntry()
	
	$Name = $User.Displayname.ToUpper()
	$Title = $User.Title.ToUpper()
	$Company = $User.Company.ToUpper()
	$Street = $User.StreetAddress.ToUpper()
	$Phone = $User.telephoneNumber
	$City = $User.l.ToUpper()
	$State = $User.st.ToUpper()
	$PostalCode = $User.PostalCode
	$Country = $User.co.ToUpper()
	$Phone = $User.telephoneNumber
	$Mobile = $User.mobile
	$Email = $User.mail.ToUpper()
	
	
	if (!$Website)
	{
		$Website = "http://www.remy-cointreau.com"
	}
	
	
	$UserDataPath = $Env:appdata
	$FolderLocation = $UserDataPath + '\Microsoft\signatures'
	if (!$FolderLocation)
	{
		mkdir $FolderLocation
	}
	
	<#
	$CompanyRegPath = "HKCU:\Software\" + $Company
	if (!(Test-Path $CompanyRegPath))
	{
		New-Item -path "HKCU:\Software" -name $Company
	}
	if (!(Test-Path $CompanyRegPath'\Outlook Signature Settings'))
	{
		New-Item -path $CompanyRegPath -name "Outlook Signature Settings"
	}
	
	
	$SigVersion = (gci $RemoteSignaturePathFull).LastWriteTime  #When was the last time the signature was written
	$ForcedSignatureNew = (Get-ItemProperty $CompanyRegPath'\Outlook Signature Settings').ForcedSignatureNew
	$ForcedSignatureReplyForward = (Get-ItemProperty $CompanyRegPath'\Outlook Signature Settings').ForcedSignatureReplyForward
	$SignatureVersion = (Get-ItemProperty $CompanyRegPath'\Outlook Signature Settings').SignatureVersion
	Set-ItemProperty $CompanyRegPath'\Outlook Signature Settings' -name SignatureSourceFiles -Value $FolderLocation
	$SignatureSourceFiles = (Get-ItemProperty $CompanyRegPath'\Outlook Signature Settings').SignatureSourceFiles
	#>
	
	if ($ForcedSignatureNew -eq '1')
	{
		#Set company signature as default for New messages
		$MSWord = New-Object -com word.application
		$EmailOptions = $MSWord.EmailOptions
		$EmailSignature = $EmailOptions.EmailSignature
		$EmailSignatureEntries = $EmailSignature.EmailSignatureEntries
		$EmailSignature.NewMessageSignature = ($Name + '-Table')
		$MSWord.Quit()
	}
	
	#Forcing signature for reply/forward messages if enabled
	if ($ForcedSignatureReplyForward -eq '1')
	{
		#Set company signature as default for Reply/Forward messages
		$MSWord = New-Object -com word.application
		$EmailOptions = $MSWord.EmailOptions
		$EmailSignature = $EmailOptions.EmailSignature
		$EmailSignatureEntries = $EmailSignature.EmailSignatureEntries
		$EmailSignature.ReplyMessageSignature = ($Name + '-Table')
		$MSWord.Quit()
	}
	
	$head = ""
	
	$head = $head + "<STYLE>"
	$head = $head + "SPAN{font-size:9pt; font-family:'Trebuchet MS'; color:gray}"
	$head = $head + ".user{font-size:10pt; font-family:'Trebuchet MS'; font-weight:bold; color:gray}"
	$head = $head + ".pipe{font-size:9pt; font-family:'Trebuchet MS'; font-weight:bold; color:red}"
	$head = $head + "TD {padding-left:15px;padding-right:15px;border-left: 2px solid red; vertical-align:top}"
	$head = $head + "</STYLE></HEAD>"
	
	$body = ""
	
	# Line 1
	$body = $body + "<BR><BR>"
	$body = $body + "<SPAN class='user'>" + $Name + "</SPAN>"
	$body = $body + "<SPAN class='pipe'> | </SPAN>"
	$body = $body + "<SPAN>" + $Title + "</SPAN>"
	$body = $body + "<SPAN class='pipe'> | </SPAN>"
	$body = $body + "<SPAN>" + $Company + "</SPAN>"
	$body = $body + "<BR>"
	
	# Line 2
	$body = $body + "<SPAN>" + $Street + "</SPAN>"
	$body = $body + "<SPAN class='pipe'> | </SPAN>"
	$body = $body + "<SPAN>" + $City + "</SPAN>"
	$body = $body + "<SPAN class='pipe'> | </SPAN>"
	$body = $body + "<SPAN>" + $PostalCode + "</SPAN>"
	$body = $body + "<SPAN class='pipe'> | </SPAN>"
	$body = $body + "<SPAN>" + $Country + "</SPAN>"
	$body = $body + "<BR>"
	
	# Line 3
	$body = $body + "<SPAN>T: " + $Phone[0] + "</SPAN>"
	$body = $body + "<SPAN class='pipe'> | </SPAN>"
	if ($Mobile -ne '')
	{
		$body = $body + "<SPAN>M: " + $Mobile[0] + "</SPAN>"
		$body = $body + "<SPAN class='pipe'> | </SPAN>"
	}
	$body = $body + "<SPAN><A HREF=`"mailto:" + $Email + "`">" + $Email + "</SPAN></A>"
	$body = $body + "<BR><BR>"
	
	$body = $body + "<A href = `"" + $Website + "`"><IMG src=`"" + $banner + "`" border=`"0`"></SPAN></A><BR><BR>"
	
	$bodyTable = ""
	
	#$bodyTable = $bodyTable + "<DIV class='Table'>"
	#$bodyTable = $bodyTable + "<DIV class='Cell'>"
	$bodyTable = $bodyTable + "<TABLE>"
	$bodyTable = $bodyTable + "<TR>"
	$bodyTable = $bodyTable + "<TD>"
	$bodyTable = $bodyTable + "<SPAN class='user'>" + $Name + "</SPAN>"
	$bodyTable = $bodyTable + "<BR>"
	$bodyTable = $bodyTable + "<SPAN>" + $Title + "</SPAN>"
	$bodyTable = $bodyTable + "<BR>"
	$bodyTable = $bodyTable + "<SPAN>" + $Company + "</SPAN>"
	$bodyTable = $bodyTable + "</TD>"
	
	$bodyTable = $bodyTable + "<TD>"
	$bodyTable = $bodyTable + "<SPAN>T: " + $Phone[0] + "</SPAN>"
	$bodyTable = $bodyTable + "<BR>"
	#if ($Mobile -ne '')
	if ($Mobile)
	{
		$bodyTable = $bodyTable + "<SPAN>M: " + $Mobile[0] + "</SPAN>"
	}
	$bodyTable = $bodyTable + "<BR>"
	$bodyTable = $bodyTable + "<SPAN><A HREF=`"mailto:" + $Email + "`">" + $Email + "</SPAN></A>"
	$bodyTable = $bodyTable + "<BR>"
	$bodyTable = $bodyTable + "<SPAN><A HREF=`"" + $Website + "`">" + $Website + "</SPAN></A>"
	$bodyTable = $bodyTable + "</TD>"
	
	$bodyTable = $bodyTable + "<TD>"
	$bodyTable = $bodyTable + "<SPAN>" + $Company + "</SPAN>"
	$bodyTable = $bodyTable + "<BR>"
	$bodyTable = $bodyTable + "<SPAN>" + $Street + "</SPAN>"
	$bodyTable = $bodyTable + "<BR>"
	$bodyTable = $bodyTable + "<SPAN>" + $City + ", </SPAN>"
	$bodyTable = $bodyTable + "<SPAN>" + $State + " </SPAN>"
	$bodyTable = $bodyTable + "<SPAN>" + $PostalCode + "</SPAN>"
	$bodyTable = $bodyTable + "<BR>"
	$bodyTable = $bodyTable + "<SPAN>" + $Country + "</SPAN>"
	$bodyTable = $bodyTable + "</TD>"
	$bodyTable = $bodyTable + "</TR>"
	
	
	$bodyTable = $bodyTable + "<TR>"
	$bodyTable = $bodyTable + "<TD>"
	$bodyTable = $bodyTable + "<A href = `"" + $Website + "`"><IMG src=`"" + $banner + "`" border=`"0`"></A>"
	$bodyTable = $bodyTable + "</TD>"
	$bodyTable = $bodyTable + "</TR>"
	$bodyTable = $bodyTable + "</TABLE>"
	
	ConvertTo-Html -Head $head -Body $body | Out-File $FolderLocation\$Name.htm
	ConvertTo-Html -Head $head -Body $bodyTable | Out-File $FolderLocation\$Name-Table.htm
	
}