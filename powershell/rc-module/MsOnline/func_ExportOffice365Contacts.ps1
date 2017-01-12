Function Export-O365Contacts {
	[CmdletBinding()]
	param
	(
		[String]$EmailAddress,
        [ValidateNotNull()]
		[System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
		$Credential = [System.Management.Automation.PSCredential]::Empty,
		[ValidateNotNullOrEmpty()]
		[ValidateRange(1, 50)]
		[int]$PageResult = 10,
        [ValidateScript({
            $Timezone = $PSItem
            if ((Get-TimeZone -ListAvailable).id -contains $Timezone) { $True }
            else { Throw "Please enter correctly formatted timezone see list here: https://technet.microsoft.com/en-us/library/cc749073(v=ws.10).aspx" }
       })]
        [string]$Timezone = (Get-TimeZone).id 
	)



		$Splatting = @{
			Credential = $Credential
			Uri = "https://outlook.office365.com/api/v1.0/users/$EmailAddress/contacts?`$top=$PageResult"

        }

 
        $headers = New-Object 'System.Collections.Generic.Dictionary[[String],[String]]'
        $headers.Add('Prefer', "outlook.timezone=`"$TimeZone`"")
        $Splatting.Add('Headers',$headers)
 
		if (-not $PSBoundParameters['EmailAddress'])
		{
			#Query the current User
			$Splatting.Uri = "https://outlook.office365.com/api/v1.0/me/contacts`$top=$PageResult"
		}
         write-verbose "splatting uri - $splatting.uri"
		$contacts = Invoke-RestMethod @Splatting  | Select-Object -ExpandProperty Value

        $contacts | Select-Object Title, 
                                  @{Name="First Name";expression={$_.GivenName}},
                                  @{Name="Middle Name";expression={$_.MiddleName}},
                                  @{Name="Last Name";expression={$_.SurName}},
                                  Suffix,
                                  Company,
                                  Department,
                                  @{Name="Job Title";expression={$_.JobTitle}},
                                  @{Name="Business Street";Expression={($_.BusinessAddress).Street}},
                                  @{Name="Business City";Expression={($_.BusinessAddress).City}},
                                  @{Name="Business State";Expression={($_.BusinessAddress).State}},
                                  @{Name="Business Postal Code";Expression={($_.BusinessAddress).PostalCode}},
                                  @{Name="Business Country/Region";Expression={($_.BusinessAddress).CountryOrRegion}},
                                  @{Name="Home Street";Expression={($_.HomeAddress).Street}},
                                  @{Name="Home City";Expression={($_.HomeAddress).City}},
                                  @{Name="Home State";Expression={($_.HomeAddress).State}},
                                  @{Name="Home Postal Code";Expression={($_.HomeAddress).PostalCode}},
                                  @{Name="Home Country/Region";Expression={($_.HomeAddress).CountryOrRegion}},
                                  @{Name="Business Phone";Expression={(($_.BusinessPhones)[0])}},
                                  @{Name="Business Phone 2";Expression={(($_.BusinessPhones)[1])}},
                                  @{Name="Email Address 1";Expression={(($_.EmailAddresses)[0]).Address}},
                                  @{Name="Email Display Name 1";Expression={(($_.EmailAddresses)[0]).Name}},
                                  @{Name="Email Address 2";Expression={(($_.EmailAddresses)[1]).Address}},
                                  @{Name="Email Display Name 2";Expression={(($_.EmailAddresses)[1]).Name}},
                                  @{Name="Email Address 3";Expression={(($_.EmailAddresses)[2]).Address}},
                                  @{Name="Email Display Name 3";Expression={(($_.EmailAddresses)[2]).Name}},
                                  @{Name="Home Phone";Expression={(($_.HomePhones)[0])}},
                                  @{Name="Home Phone 2";Expression={(($_.HomePhones)[1])}},
                                  MobilePhone1, 
                                  Notes,
                                  Birthday 
}