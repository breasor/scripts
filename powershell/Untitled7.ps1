
$keys = 0
$size = 0
$myBucketName = "remy-us-east1-fs-storage"
$myFolder = "termed/"

$bucket = Get-S3Object -BucketName $myBucketName -key $myFolder
$bucket | % { $size += $_.Size; $keys++}

$size = [math]::Round($size/1GB,2)
"Total folder size: $size GB."
"The total number of keys: $keys"