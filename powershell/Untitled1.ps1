Function Get-IP( $Computer )
# Returns the TCP/IP Properties of the $Computer

{
     #$colItems = get-wmiobject -class "Win32_NetworkAdapterConfiguration" -namespace "root\CIMV2" -computername $Computer -filter "IPEnabled = true"
     Return (get-wmiobject -class "Win32_NetworkAdapterConfiguration" -namespace "root\CIMV2" -computername $Computer -filter "IPEnabled = true")
}