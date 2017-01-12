Function Get-DGMemberShip {
    param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [ValidateScript({
            $Identity = $PSItem
            if (($Identity = Get-Recipient $Identity -Erroraction stop).RecipientType -eq "UserMailbox") { $True }
            else { Throw "Mailbox does not exist for user: $($Identity)" }
       })]
    [string]$Identity
    )
    
    $distinguishedName =  (Get-Mailbox -Identity $Identity).distinguishedname

    Get-DistributionGroup -Filter "Members -like '$($distinguishedName)'" -ErrorAction silentlycontinue 
            
}