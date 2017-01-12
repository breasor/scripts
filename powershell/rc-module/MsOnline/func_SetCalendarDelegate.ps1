function Set-CalendarDelegate {
    param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [ValidateScript({
            $Identity = $PSItem
            if ((Get-Recipient $Identity -Erroraction stop).RecipientType -eq "UserMailbox") { $True }
            else { Throw "Mailbox does not exist for user: $($Identity)" }
       })]
    [string]$Identity,
    [Parameter(Mandatory=$true)]
    [ValidateSet("Read","Update", "Limited", "None")]
    [string]$AccessRights,
    [Parameter(Mandatory=$true)]
    [ValidateScript({
        $Identity = $PSItem
        if ((Get-Recipient $Identity -Erroraction stop).RecipientType -eq "UserMailbox") { $True }
        else { Throw "Mailbox does not exist for assistant: $($Identity)" }
    })]
    [Alias("Assistant")]
    [string]$User
    )
 
    $UserMailbox = (Get-Mailbox $Identity)
    $AssistantMailbox = (Get-Mailbox $User).distinguishedname

    try { 
        Remove-MailboxFolderPermission -Identity "$($UserMailbox):\Calendar" -User $AssistantMailbox -Confirm:$true -WhatIf
        Remove-MailboxFolderPermission -Identity "$($UserMailbox):\Deleted Items" -User $AssistantMailbox -Confirm:$true -WhatIf
        Remove-MailboxFolderPermission -Identity "$($UserMailbox):\Calendar" -User $AssistantMailbox -Confirm:$true -WhatIf
        Remove-MailboxFolderPermission -Identity "$($UserMailbox):\Deleted Items" -User a-breasorf@remyusa.com -Confirm:$true -WhatIf
    }
    catch  {
        $_.Exception|format-list -force
    }
    
    try { 
        Add-MailboxFolderPermission -Identity brett.reasor@remyusa.com:\calendar -User a-breasor@remyusa.com -AccessRights reviewer -ErrorAction Stop
    }
    catch [Exception] {
        Set-MailboxFolderPermission -Identity brett.reasor@remyusa.com:\calendar -User a-breasor@remyusa.com -AccessRights reviewer -ErrorAction Stop
    }

    
    <#
    if ($AccessRights -eq "Update") 
    {
        $MailboxFolders = @(($UserMailbox | Get-MailboxFolderStatistics | Where {$_.foldertype -eq "Calendar" -or $_.foldertype -eq "DeletedItems" } ).Identity).replace("\",":\")
    }
    else
    {
        $MailboxFolders = @(($UserMailbox | Get-MailboxFolderStatistics | Where {$_.foldertype -eq "Calendar"  } ).Identity).replace("\",":\")    
    }

    
    foreach ($MailboxFolder in $MailboxFolders)
    {
                    
        $permissions = Get-MailboxFolderPermission -Identity $MailboxFolder
        Remove-MailboxFolderPermission -Identity $MailboxFolder -User $AssistantMailbox -ErrorAction Stop -WhatIf

        Set-MailboxFolderPermission -Identity $MailboxFolder -User $AssistantMailbox -AccessRights readitems -WhatIf
        
    }
    #>
}