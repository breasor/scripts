<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.93
	 Created on:   	9/9/2015 3:24 PM
	 Created by:   	breasor
	 Organization: 	Remy Cointreau USA
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
<#
$config = Get-Content "C:\ESSBASE\Gen5\config\Gen5CloseCalendar.txt"
$closeCalendar = "C:\ESSBASE\Gen5\config\CloseCalendar.xml"
$XmlWriter = New-Object System.Xml.XmlTextWriter($closeCalendar, $Null)
$XmlWriter.Formatting = 'Indented'
$XmlWriter.Indentation = 1
$XmlWriter.IndentChar = "`t"

# write the header
$xmlWriter.WriteStartDocument()

# set XSL statements
$xmlWriter.WriteProcessingInstruction("xml-stylesheet", "type='text/xsl' href='style.xsl'")
$XmlWriter.WriteComment('Close Calendar')
$XmlWriter.WriteStartElement('Calendar')
$XmlWriter.WriteAttributeString('App', 'Gen5')

foreach ($row in $config)
{
	
	$fields = $row.split("|")
	
	#$XmlWriter.WriteStartElement('Calendar')
	<#if ($fields[0] -eq "FY1516")
	{
		$XmlWriter.WriteStartElement('FiscalYear')
		$XmlWriter.WriteAttributeString('Year', $fields[0])
		$XmlWriter.WriteElementString('CurMonth', $fields[1])
		$XmlWriter.WriteElementString('Depletion', $fields[2])
		$XmlWriter.WriteElementString('SCO', $fields[3])
		$XmlWriter.WriteElementString('SCOTrup', $fields[4])
		$XmlWriter.WriteElementString('SCostTrup', $fields[5])
		$XmlWriter.WriteEndElement()
	}
	#>
	<#
	$XmlWriter.WriteStartElement('Entry')
	$XmlWriter.WriteElementString('Year', $fields[0])
	$XmlWriter.WriteElementString('CurMonth', $fields[1])
	$XmlWriter.WriteElementString('Depletion', $fields[2])
	$XmlWriter.WriteElementString('SCO', $fields[3])
	$XmlWriter.WriteElementString('SCOTrup', $fields[4])
	$XmlWriter.WriteElementString('SCostTrup', $fields[5])
	$XmlWriter.WriteEndElement()
	
	New-Object System.Management.Automation.PSObject -Property @{
		Year = $fields[1]
		CurMonth = $fields[2]
		Depletion = $fields[3]
		SCO = $fields[4]
		SCOTrup = $fields[5]
		SCostTrup = $fields[6]
	}
	#$XmlWriter.WriteEndElement())
}

$XmlWriter.WriteEndElement()


$xmlWriter.Flush()
$xmlWriter.Close()

notepad $closeCalendar
#>