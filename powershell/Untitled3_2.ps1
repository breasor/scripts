	
configuration UnZipFile {
 
    param (
        [Parameter(Mandatory=$True)]
        [string[]]$ComputerName,
 
        [string]$Path,
        [string]$Destination
    )
 
    node $ComputerName {
 
        archive ZipFile {
        Path = $Path
        Destination = $Destination
        Ensure = 'Present'
 
        }
 
    }
 
}