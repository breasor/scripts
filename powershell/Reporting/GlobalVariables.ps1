
$SMTPSRV ="smtp.remyusa.com"
# Report Sender
$EmailFrom ="Office365-Admin@remy-cointreau.com"
# Report Recipient
$EmailTo ="brett.reasor@remyusa.com"

$today = Get-Date

function Console-ShowMessage([string]$type,$message){
    if($verbose){
        Write-Host ("[{0}] [" -f (Get-Date)) -NoNewline;
        switch ($type){
            "done" { Write-Host "done" -ForegroundColor Green -NoNewline;}
            "info"    { Write-Host "info"    -ForegroundColor DarkCyan -NoNewline; }
            "warn" { Write-Host "warn" -ForegroundColor DarkYellow -NoNewline; }
            "fail"   { Write-Host "fail"   -ForegroundColor Red -NoNewline; }
            default   { Write-Host $type -NoNewline; }
        }
        Write-Host ("]`t{0}{1}" -f $message,$Global:blank)
    }
}