#captures debug statements globally
function Debug {
    param($text="")
    
    Write-Output $text
}

$authToken = Get-PBIAuthToken -clientId "8dee2da7-8ba1-4ad4-97c9-dd142f52d564" #-ForceAskCredentials


$adminTable = @{
    name = "AdminRoles";
    columns = @(
        @{
            name = "DisplayName";
           dataType = "String"
        }
        ,@{
            name = "EmailAddress";
           dataType = "String"
        }
        ,@{
            name = "IsLicensed";
           dataType = "boolean"
        }
        ,@{
            name = "objectID";
           dataType = "String"
        }   
        ,@{
            name = "RoleName";
           dataType = "String"
        }
        ,@{
            name = "RoleMemberType";
           dataType = "String"
        }
        ,@{
            name = "StrongAuthentication";
           dataType = "String"
        }
    )
}

$skuReportTable =  @{
    name = "Skus";
    columns = @(
        @{
            name = "SkuPartNumber";
           dataType = "String"
        }
        ,@{
            name = "ActiveUnits";
           dataType = "Int64"
        }
        ,@{
            name = "ConsumedUnits";
           dataType = "Int64"
        }
        ,@{
            name = "FreeUnits";
           dataType = "Int64"
        }
    )
}


$skuTable  = @{
    name = "Skus";
    columns = @(
        @{
            name = "skuID";
           dataType = "String"
        },
        @{
            name = "DisplayName";
           dataType = "String"
        }
    )
}

$servicePlanTable = @{
    name = "ServicePlans";
    columns = @(
        @{
            name = "UserPrincipalName";
           dataType = "String"
        }
        ,@{
            name = "ServicePlan";
           dataType = "String"
        }
        ,@{
            name = "ProvisioningStatus";
           dataType = "String"
        }
    )
}

$licenseTable = @{
    name = "LicensedUsers";
    columns = @(
        @{
            name = "UserPrincipalName";
           dataType = "String"
        }
        ,@{
            name = "AccountSKUId";
           dataType = "String"
        }
    )
}

$dataCenterTable = @{
    name = "DataCenters";
    columns = @(
        @{
            name = "DataCenter";
           dataType = "String"
        }
        ,@{
            name = "Location";
           dataType = "String"
        }
        ,@{
            name = "Region";
           dataType = "String"
        }
    )
}

$userTable = @{
    name = "MSolUsers";
    columns = @(
        @{
            name = "UserPrincipalName";
           dataType = "String"
        }
        ,@{
            name = "objectId";
           dataType = "String"
        }
        ,@{
            name = "isLicensed";
           dataType = "Boolean"
        }
        ,@{
            name = "BlockCredential";
           dataType = "Boolean"
        }
        ,@{
            name = "Department";
           dataType = "String"
        }
        ,@{
            name = "Country";
           dataType = "String"
        }
        ,@{
            name = "SignInName";
           dataType = "String"
        }
        ,@{
            name = "State";
           dataType = "String"
        }
        ,@{
            name = "Title";
           dataType = "String"
        }
        ,@{
            name = "usageLocation";
           dataType = "String"
        }
        ,@{
            name = "immutableId";
           dataType = "String"
        }
        ,@{
            name = "LastDirSyncTime";
           dataType = "DateTime"
        }
        ,@{
            name = "DisplayName";
           dataType = "String"
        }
        ,@{
            name = "CloudExchangeRecipientDisplayType";
           dataType = "String"
        }
        ,@{
            name = "City";
           dataType = "String"
        }
    )
}

$mboxTable = @{
    name = "Mailboxes";
    columns = @(
        @{
            name = "ExchangeGuid";
           dataType = "String"
        }
        ,@{
            name = "SamAccountName";
           dataType = "String"
        }
        ,@{
            name = "Alias";
           dataType = "String"
        }
        ,@{
            name = "BlockCredential";
           dataType = "Boolean"
        }
        ,@{
            name = "ServerName";
           dataType = "String"
        }
        ,@{
            name = "Office";
           dataType = "String"
        }
        ,@{
            name = "UserPrincipalName";
           dataType = "String"
        }
        ,@{
            name = "MailboxPlan";
           dataType = "String"
        }
        ,@{
            name = "ArchiveStatus";
           dataType = "String"
        }
        ,@{
            name = "ArchiveState";
           dataType = "String"
        }
        ,@{
            name = "immutableId";
           dataType = "String"
        }
        ,@{
            name = "RemoteRecipientType";
           dataType = "String"
        }
        ,@{
            name = "IsInactiveMailbox";
           dataType = "Boolean"
        }
        ,@{
            name = "IsDirSynced";
           dataType = "Boolean"
        }
        ,@{
            name = "AccountDisabled";
           dataType = "Boolean"
        }
        ,@{
            name = "DisplayName";
           dataType = "String"
        }
        ,@{
            name = "RecipientTypeDetails";
           dataType = "String"
        }
        ,@{
            name = "Identity";
           dataType = "String"
        }
        ,@{
            name = "Name";
           dataType = "String"
        }
        ,@{
            name = "WhenCreated";
           dataType = "DateTime"
        }
        ,@{
            name = "lastlogontime";
           dataType = "DateTime"
        }
        ,@{
            name = "IsClutterEnabled";
           dataType = "Boolean"
        }
        ,@{
            name = "TotalItemSize";
           dataType = "Int64"
        }
        ,@{
            name = "TotalDeletedItemSize";
           dataType = "Int64"
        }
        ,@{
            name = "ItemCount";
           dataType = "Int64"
        }
    )
}




$dataSetName = "O365Licensing"
$dataSetSchema = @{
    name = $dataSetName;
    tables = @(
        $adminTable
        ,$dataCenterTable
        ,$licenseTable
        ,$servicePlanTable
        ,$userTable
        ,$skuReportTable
        ,$mboxTable
        ,$skuTable
    )
}   

# Test the existence of the dataset
Debug -text ("Working on {0}" -f "Checking DataSet") -action "write"
if (!(Test-PBIDataSet -authToken $authToken -name $datasetName) )
{  
    #create the dataset
    Debug -text ("Working on {0}" -f "Creating DataSet") -action "write"
    $pbiDataSet = New-PBIDataSet -authToken $authToken -dataSet $dataSetSchema #-verbose

    Debug -text ("Writing {0} [{1}]" -f "DataSet Values", $allUtil.Count) -action "write"
    #$allIncidents | Out-PowerBI -AuthToken $authToken -dataSetName $datasetName -tableName $adminTable.Name -verbose
    
    Update-PBITableSchema -authToken $authToken -dataSetId $pbiDataSet.id -table $dataCenterTable -verbose
    Update-PBITableSchema -authToken $authToken -dataSetId $pbiDataSet.id -table $skuTable -verbose
    Update-PBITableSchema -authToken $authToken -dataSetId $pbiDataSet.id -table $licenseTable -verbose
    Update-PBITableSchema -authToken $authToken -dataSetId $pbiDataSet.id -table $adminTable -verbose
    Update-PBITableSchema -authToken $authToken -dataSetId $pbiDataSet.id -table $servicePlanTable -verbose
    Update-PBITableSchema -authToken $authToken -dataSetId $pbiDataSet.id -table $userTable -verbose
    Update-PBITableSchema -authToken $authToken -dataSetId $pbiDataSet.id -table $skuReportTable -verbose
    Update-PBITableSchema -authToken $authToken -dataSetId $pbiDataSet.id -table $mboxTable -verbose
    
    #Update-PBITableSchema -authToken $authToken -dataSetId $pbiDataSet.id -table $skuTable -verbose
   Import-Csv C:\exploit\skus.csv | Out-PowerBI -AuthToken $authToken -DataSetName $dataSetName -TableName $skuTable.name -Verbose
    Import-Csv C:\exploit\datacenters.csv | Out-PowerBI -AuthToken $authToken -DataSetName $dataSetName -TableName $dataCenterTable.name -Verbose
}
else
{
    $pbiDataSet = Get-PBIDataSet -authToken $authToken -name $datasetName

    #clear the dataset and update the schema if necessary
    Debug -text ("Working on {0}" -f "Clearing DataSet") -action "write"
    Clear-PBITableRows -authToken $authToken -dataSetName $datasetName -tableName $adminTable.Name -verbose

    Debug -text ("Working on {0}" -f "Updating DataSet Schema") -action "write"
    Update-PBITableSchema -authToken $authToken -dataSetId $pbiDataSet.id -table $adminTable -verbose

    Debug -text ("Writing {0} [{1}]" -f "DataSet Values", $allUtil.Count) -action "write"
    #$allIncidents | Out-PowerBI -AuthToken $authToken -dataSetName $datasetName -tableName $adminTable.Name -verbose
}
#endsection


$adminRoles = @()
ForEach ($role in (Get-MsolRole)) {
    $adminObject = @{}
    $adminRoles  += Get-MsolRoleMember -RoleObjectId $role.objectid | 
        Select-Object  objectId,
                       DisplayName,
                       EmailAddress,
                       IsLicensed,
                       RoleMemberType,
                       @{name="RoleName";expression={$role.Name}},
                       @{name="StrongAuthentication";expression={$_.StrongAuthenticationRequirements.State}} |
       Out-PowerBI -AuthToken $authToken -DataSetName $dataSetName -TableName $adminTable.name -Verbose
        
}


$userList = @()
$licensedUsers = @()
$servicePlans = @()

#foreach ($user in (Get-MsolUser  -All)) {
foreach ($user in (Get-MsolUser  -MaxResults 10)) {
#foreach ($user in $msolUsers) {

    $userObject = @{}
    $userObject.objectId = $user.objectId
    $userObject.whencreated = $user.whencreated
    $userObject.isLicensed = $user.isLicensed
    $userObject.BlockCredential = $user.BlockCredential
    $userObject.Department = $user.Department
    $userObject.Country = $user.Country
    $userObject.SignInName = $user.SignInName
    $userObject.State = $user.State
    $userObject.Title = $user.Title
    $userObject.usagelocation = $user.usagelocation
    $userObject.immutableid = $user.immutableid
    $userObject.LastDirSyncTime = $user.LastDirSyncTime
    $userObject.DisplayName = $user.DisplayName
    $userObject.CloudExchangeRecipientDisplayType = $user.CloudExchangeRecipientDisplayType
    $userObject.City = $user.City
    $userList += New-Object -TypeName PSObject -Property $userObject
    $upn = $user.UserPrincipalName
    foreach ($license in $user.Licenses) {
        $licenseObject = @{}
        $licenseObject.UserPrincipalName = $upn
        $licenseObject.AccountSKUId = $license.AccountSKU.SkuPartNumber
        $licensedUsers += New-Object -TypeName PSObject -Property $licenseObject
    }
    foreach ($plan in $user.Licenses.servicestatus) {
        $serviceObject = @{}
        $serviceObject.UserPrincipalName = $upn
        $serviceObject.ServicePlan = $plan.serviceplan.ServiceName
        $serviceObject.ProvisioningStatus = $plan.ProvisioningStatus
        $servicePlans += New-Object -TypeName PSObject -Property $serviceObject
    }
}

$userList | Out-PowerBI -AuthToken $authToken -DataSetName $dataSetName -TableName $userTable.name -Verbose
$licensedUsers | Out-PowerBI -AuthToken $authToken -DataSetName $dataSetName -TableName $licenseTable.name -Verbose
$servicePlans | Out-PowerBI -AuthToken $authToken -DataSetName $dataSetName -TableName $servicePlanTable.name -Verbose


<#
        $adminTable
        ,$dataCenterTable
        ,$licenseTable
        ,$servicePlanTable
        ,$userTable
        ,$skuReportTable
        ,$mboxTable
        ,$skuTable

        #>