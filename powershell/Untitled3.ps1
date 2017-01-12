
$alias = "michael.staib"
foreach ($group in Get-DistributionGroup -ResultSize unlimited)
{

    if ((Get-DistributionGroupMember $group.identity | select -Expand alias) -contains $alias)
    
    {$group.name}

    }