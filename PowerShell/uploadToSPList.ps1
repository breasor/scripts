$SPClientDirRegKey = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\SharePoint Client Components\15.0" -PSProperty "Location" -ErrorAction:SilentlyContinue
if ($SPClientDirRegKey -ne $null) 
{
	$moduleFilePath1 = $SPClientDirRegKey.'Location' + 'ISAPI\Microsoft.SharePoint.Client.dll'
    $moduleFilePath2 = $SPClientDirRegKey.'Location' + 'ISAPI\Microsoft.SharePoint.Client.Runtime.dll'
	Import-Module $moduleFilePath1
    Import-Module $moduleFilePath2
}
else 
{
	$errorMsg = "Please install SharePoint Server 2013 Client Components SDK"
	throw $errorMsg
    }

#$url = "https://remycointreau.sharepoint.com"
$url = "https://remycointreau.sharepoint.com/Team/rc_americas/sales"
$username = "a-breasor@remyusa.com"
#$password = Read-Host "password" -AsSecureString
$password = ConvertTo-SecureString "#########!" -AsPlainText -Force

$ctx=New-Object Microsoft.SharePoint.Client.ClientContext($Url)
$ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $password)
$ctx.ExecuteQuery()  

$ctx.Load($ctx.Web.Lists)
$ctx.ExecuteQuery()
Write-Host $ctx.Web.Lists.Count


  $ctx.Load($ctx.Web.Lists)
  $ctx.ExecuteQuery()
  Write-Host 
  Write-Host $ctx.Url -BackgroundColor White -ForegroundColor DarkGreen
  foreach( $ll in $ctx.Web.Lists)
  {     
        $ctx.Load($ll.RootFolder)
        $ctx.Load($ll.DefaultView)
        $ctx.Load($ll.Views)
        $ctx.Load($ll.WorkflowAssociations)
        try
        {
        $ctx.ExecuteQuery()
        }
        catch
        {
        }

        if($IncludeAllProperties)
        {
        
        $obj = New-Object PSObject
  $obj | Add-Member NoteProperty Title($ll.Title)
  $obj | Add-Member NoteProperty Created($ll.Created)
  $obj | Add-Member NoteProperty Tag($ll.Tag)
  $obj | Add-Member NoteProperty RootFolder.ServerRelativeUrl($ll.RootFolder.ServerRelativeUrl)
  $obj | Add-Member NoteProperty BaseType($ll.BaseType)
  $obj | Add-Member NoteProperty BaseTemplate($ll.BaseTemplate)
  $obj | Add-Member NoteProperty AllowContenttypes($ll.AllowContenttypes)
  $obj | Add-Member NoteProperty ContentTypesEnabled($ll.ContentTypesEnabled)
  $obj | Add-Member NoteProperty DefaultView.Title($ll.DefaultView.Title)
  $obj | Add-Member NoteProperty Description($ll.Description)
  $obj | Add-Member NoteProperty DocumentTemplateUrl($ll.DocumentTemplateUrl)
  $obj | Add-Member NoteProperty DraftVersionVisibility($ll.DraftVersionVisibility)
  $obj | Add-Member NoteProperty EnableAttachments($ll.EnableAttachments)
  $obj | Add-Member NoteProperty EnableMinorVersions($ll.EnableMinorVersions)
  $obj | Add-Member NoteProperty EnableFolderCreation($ll.EnableFolderCreation)
  $obj | Add-Member NoteProperty EnableVersioning($ll.EnableVersioning)
  $obj | Add-Member NoteProperty EnableModeration($ll.EnableModeration)
  $obj | Add-Member NoteProperty Fields.Count($ll.Fields.Count)
  $obj | Add-Member NoteProperty ForceCheckout($ll.ForceCheckout)
  $obj | Add-Member NoteProperty Hidden($ll.Hidden)
  $obj | Add-Member NoteProperty Id($ll.Id)
  $obj | Add-Member NoteProperty IRMEnabled($ll.IRMEnabled)
  $obj | Add-Member NoteProperty IsApplicationList($ll.IsApplicationList)
  $obj | Add-Member NoteProperty IsCatalog($ll.IsCatalog)
  $obj | Add-Member NoteProperty IsPrivate($ll.IsPrivate)
  $obj | Add-Member NoteProperty IsSiteAssetsLibrary($ll.IsSiteAssetsLibrary)
  $obj | Add-Member NoteProperty ItemCount($ll.ItemCount)
  $obj | Add-Member NoteProperty LastItemDeletedDate($ll.LastItemDeletedDate)
  $obj | Add-Member NoteProperty MultipleDataList($ll.MultipleDataList)
  $obj | Add-Member NoteProperty NoCrawl($ll.NoCrawl)
  $obj | Add-Member NoteProperty OnQuickLaunch($ll.OnQuickLaunch)
  $obj | Add-Member NoteProperty ParentWebUrl($ll.ParentWebUrl)
  $obj | Add-Member NoteProperty TemplateFeatureId($ll.TemplateFeatureId)
  $obj | Add-Member NoteProperty Views.Count($ll.Views.Count)
  $obj | Add-Member NoteProperty WorkflowAssociations.Count($ll.WorkflowAssociations.Count)



        Write-Output $obj 

        }
        else
        {

        
       
        
        $obj = New-Object PSObject
  $obj | Add-Member NoteProperty Title($ll.Title)
  $obj | Add-Member NoteProperty Created($ll.Created)
  $obj | Add-Member NoteProperty RootFolder.ServerRelativeUrl($ll.RootFolder.ServerRelativeUrl)
        
        
        Write-Output $obj 
        
        
     }  
        
        }
  


$SPServer = "https://remycointreau.sharepoint.com"
$SPAppList = "Team/rc_americas/sales/_layouts/15/start.aspx#/Lists/WholesalerBroker%20Contacts"
$SPList = "/Team/rc_americas/sales/Lists/WholesalerBroker%20Contacts"

$list=$ctx.Web.Lists.GetByTitle($SPList)
  $ctx.Load($list)
  $ctx.Load($list.Views)
  $ctx.ExecuteQuery()
