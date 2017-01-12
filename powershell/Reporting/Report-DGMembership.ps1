<#

$DistributionGroups = Get-DistributionGroup
$DynDistributionGroups = Get-DynamicDistributionGroup
 
$FilePath = "C:\exploit\DistributionGroupMembers.csv"
 
# Read Static Distribution Groups
foreach ($DistributionGroup in $DistributionGroups) {
    Get-DistributionGroupMember $DistributionGroup.PrimarySMTPAddress | Sort-Object name | Select-Object @{ Label = "Distribution Group"; Expression = { $DistributionGroup.name } }, Name | Export-Csv -Path $FilePath -Delimiter ";" -NoTypeInformation -Append -Force
}
 
# Read Dynamic Distribution Groups
foreach ($DynDistributionGroup in $DynDistributionGroups)
{
    Get-Recipient -RecipientPreviewFilter $DynDistributionGroup.RecipientFilter | Sort-Object name | Select-Object @{ Label = "Distribution Group"; Expression = { $DynDistributionGroup.name } }, Name | Export-Csv -Path $FilePath -Delimiter ";" -NoTypeInformation -Append -Force
}

#>

ForEach ($dg in Get-DistributionGroup) {
            Get-DistributionGroupMember -Identity $dg.guid | 
                Select-Object @{Name="Distribution Group";Expression={$dg.name}},
                              UserPrincipalName,
                              DisplayName


                            }