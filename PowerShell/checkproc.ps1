$outfile = gci C:\exploit\process_2015-10-25_0830\process_2015-10-25_0400.log
$lines = Get-Content $outfile.FullName | Where-Object {$_ -match '\s'}

$a = import-csv -Delimiter "`t" -Path $outfile.fullname

$lines = get-content $outfile.FullName |
    select -Property @{name='Caption';expression={$_.Substring(0,23).Trim()}},
                     @{name='PageFaults';expression={$_.Substring(1407,1418).Trim()}}

$lines

<#
 
$outfile = get-childitem -filter "*.out" d:\unix\gen5\logs | sort LastWriteTime  |select -last 1
#$dir | get-member
#$outfile

$alltime = 0
$lines = (get-content $outfile.FullName | Where-Object {$_ -match '\S'} )
foreach ($line in $lines)
{
    $line = ($line  | select-string -Pattern "Total Calc Elapsed") -split "\s+"
#    $line.split() 
    $calc = $line[-4] -replace '[][]',''
    $calcTime = [double]($line[-2] -replace '[][]','')
    #$line.line.split("-")[2]
    if ($calc) {
    write-host $calc $calcTime}
    $alltime = $alltime + $calcTime
    #$calcTime
}

write-host ("{0:N2}" -f ($alltime/60/60) + " hours to run calculations")
#>
