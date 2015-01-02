<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.74
	 Created on:   	10/29/2014 2:39 PM
	 Created by:   	breasor
	 Organization: 	Remy Cointreau USA
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

param (
	$Retention = "7",
	[string] $Billing = "US",
	[string] $LogFile = "C:\Scripts\EBS-Backup.log"
)



begin
{
	##IMPORT AWS MODULE
	Import-Module "c:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"
	
	#$InstanceId = (New-Object System.Net.WebClient).DownloadString("http://169.254.169.254/latest/meta-data/instance-id")
	#$InstanceId = "i-8ed40a64"
	
	# Define filters.
	$BackupFilter = New-Object Amazon.EC2.Model.Filter
	$BackupFilter.Name = "tag:Backup"
	$BackupFilter.Value.Add("Remote")
	
	$IsRunningFilter = New-Object Amazon.EC2.Model.Filter
	$IsRunningFilter.Name = "instance-state-code"
	$IsRunningFilter.Value = "16"
	
	$instances = (Get-EC2Instance -Filter $BackupFilter,$IsRunningFilter ).instances.instanceid

}

process
{
	function log($string)
	{
		Write-Output "$(Get-Date -Format s) $string"
		$string | out-file -Filepath $LogFile -append
	}
	
	foreach ($InstanceId in $instances)
	{
		$volumes = ((Get-EC2Volume).Attachment | where { $_.InstanceId -eq $InstanceId }).VolumeId
		foreach ($volumeId in $volumes)
		{
			$description = "$volumeId-backup-$(Get-Date -format yyyy-MM-dd)"
			
			$Snapshot = New-EC2Snapshot $volumeId -Description $description
			
			$Tags = @()
			$CreatedByTag = New-Object Amazon.EC2.Model.Tag
			$CreatedByTag.Key = "CreatedBy"
			$CreatedByTag.Value = "RemoteBackup"
			$Tags += $CreatedByTag
			$BillingTag = New-Object Amazon.EC2.Model.Tag
			$BillingTag.Key = "Billing"
			$BillingTag.Value = (Get-EC2Tag | Where-Object { $_.ResourceID -eq $InstanceId -and $_.Key -eq "Billing" }).value
			$Tags += $BillingTag
			$NameTag = New-Object Amazon.EC2.Model.Tag
			$NameTag.Key = "Name"
			$NameTag.Value = (Get-EC2Tag | Where-Object { $_.ResourceID -eq $InstanceId -and $_.Key -eq "Name" }).value
			$Tags += $NameTag
			
			if ($Snapshot)
			{
				New-EC2Tag -ResourceId $Snapshot.SnapshotId -Tags $Tags #-StoredCredentials EBS-Snapshot
				log "Backing Up $($InstanceId) with Snapshot $($Snapshot.SnapShotId)"
			}
		}
		
	}
}

<#
foreach ($volume in $volumes)
	{
		
		$description = "$hostname-backup-$(Get-Date -format yyyy-MM-dd)"
		
    #    <#
		
		$Snapshot = New-EC2Snapshot $volume.VolumeId -Description $description -StoredCredentials EBS-Snapshot
		
		log "Created Snapshot $($Snapshot.SnapshotId)"
		
		$Tags = @()
		$CreatedByTag = New-Object Amazon.EC2.Model.Tag
		$CreatedByTag.Key = "CreatedBy"
		$CreatedByTag.Value = "AutomatedBackup"
		$Tags += $CreatedByTag
		$BillingTag = New-Object Amazon.EC2.Model.Tag
		$BillingTag.Key = "Billing"
		if (!$CheckBillingTag)	{ $BillingTag.Value = $Billing }	
		else { $BillingTag.Value = $CheckBillingTab }
		$BillingTag.Value = "US"
		$Tags += $BillingTag
		$NameTag = New-Object Amazon.EC2.Model.Tag
		$NameTag.Key = "Name"
		$NameTag.Value = (Get-EC2Tag | Where-Object { $_.ResourceID -eq $InstanceId -and $_.Key -eq "Name" })
		
		if ($Snapshot)
		{
			New-EC2Tag -ResourceId $Snapshot.SnapshotId -Tags $Tags -StoredCredentials EBS-Snapshot
		}
		
		#>
<#		
		# Criteria to use to filter the results returned.
		$volumeID = $volume.VolumeId
	
		# Define filters.
		$filter1 = New-Object Amazon.EC2.Model.Filter
		$filter1.Name = "volume-id"
		$filter1.Value.Add($volumeID)
		
		$filter2 = New-Object Amazon.EC2.Model.Filter
		$filter2.Name = "tag:CreatedBy"
		$filter2.Value = "AutomatedBackup"
		
		$snapshots = Get-EC2Snapshot -Filter $filter1,$filter2
		
		
		foreach ($snapshot in $snapshots)
		{			
			if (((Get-Date) - $snapshot.StartTime).Days -gt $Retention)
			{
				log "Deleting Snapshot $($snapshot.SnapshotId)"
				Remove-EC2Snapshot -SnapshotId $snapshot.SnapshotId }
			else
			{
				log "Not Deleting $($snapshot.Description) - $($snapshot.SnapShotID)"
			}
			
			#$snapshot_age
			
		}
	
}

}
#>
