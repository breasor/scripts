$FileName = "C:\exploit\REMY CASINO SURVEY.xlsx"
$SheetName = "Sheet1"

$xl = New-Object -ComObject Excel.Application
#$xl.Visible = $false

$wb = $xl.Workbooks.open($FileName)
$ws = $wb.Sheets.Item(1)
$rows = $ws.UsedRange.Rows.Count
#$ws.Columns.item('G').NumberFormat = 'm/d/yyyy'

$results = @()
for($intRow = 2 ; $intRow -le $rows ; $intRow++)
{
    $row = [ordered]@{
        'SurveyID'  = $ws.cells.item($intRow,1).value2
        'Num'    = $ws.cells.item($intRow,2).value2
        'Question' = $ws.cells.item($intRow,3).value2
        'Answer'  = $ws.cells.item($intRow,4).value2
        'Dflt' = $ws.cells.item($intRow,5).value2
        'HelpText' = $ws.cells.item($intRow,6).value2
        'DateSent' = (Get-Date ([DateTime]::FromOADate($ws.cells.item($intRow,7).value2)) -Format d)
        'StrucID' = $ws.cells.item($intRow,8).value2
        'StrucName' = $ws.cells.item($intRow,9).value2
        'ProdLevel' = $ws.cells.item($intRow,10).value2
        'ProdLevelID' = $ws.cells.item($intRow,11).value2
        'ProdSize' = $ws.cells.item($intRow,12).value2
        'ProdCategory' = $ws.cells.item($intRow,13).value2
        'ProdType' = $ws.cells.item($intRow,14).value2
        'QuesTypeID' = $ws.cells.item($intRow,15).value2
        'DrinkSKU' = $ws.cells.item($intRow,16).value2
        'Opt10' = $ws.cells.item($intRow,17).value2
        'Opt11' = $ws.cells.item($intRow,18).value2
        'Opt12' = $ws.cells.item($intRow,19).value2
        'CustID' = $ws.cells.item($intRow,20).value2
        'TradeName' = $ws.cells.item($intRow,21).value2
        'Street' = $ws.cells.item($intRow,22).value2
        'City' = $ws.cells.item($intRow,23).value2
        'State' = $ws.cells.item($intRow,24).value2
        'Zip' = $ws.cells.item($intRow,25).value2
        'Chain' = $ws.cells.item($intRow,26).value2
        'Category' = $ws.cells.item($intRow,27).value2
        'SpiritVolume' = $ws.cells.item($intRow,28).value2
        'WineVolume' = $ws.cells.item($intRow,29).value2
        'BeerVolume' = $ws.cells.item($intRow,30).value2
        'CustTypeID' = $ws.cells.item($intRow,31).value2
        'RepID' = $ws.cells.item($intRow,32).value2
        'RepName' = $ws.cells.item($intRow,33).value2
        'Team' = $ws.cells.item($intRow,34).value2
    } 
    
    $obj = New-Object -Type PSObject -Property $row
    
    
    $results += $obj
}

#write-host $results
$results | export-csv -delimiter "|" -path "C:\exploit\REMY CASINO SURVEY.txt" -NoTypeInformation

$wb.close()
$xl.quit()

