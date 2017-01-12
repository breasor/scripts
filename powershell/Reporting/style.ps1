# Report HTML structure
$ReportHTML = @"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <title>_HEADER_</title>
      <meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
      <style type='text/css'>
         table	{
            width: 100%;
            margin: 0px;
            padding: 0px;
         }
         tr:nth-child(even) { 
            background-color: #e5e5e5; 
         }
         td {
               vertical-align: top; 
               font-family: Tahoma, sans-serif;
               font-size: 8pt;
               padding: 0px;
         }
         th {
               vertical-align: top;  
               color: #018AC0; 
               text-align: left;
               font-family: Tahoma, sans-serif;
               font-size: 8pt;
         }
         .pluginContent td { padding: 5px; }
         .warning { background: #FFFBAA !important }
         .critical { background: #FFDDDD !important }
      </style>
   </head>
   <body style="padding: 0 10px; margin: 0px; font-family:Arial, Helvetica, sans-serif; ">
      <a name="top" />
        <table width='100%' style='background-color: #0A77BA; border-collapse: collapse; border: 0px; margin: 0; padding: 0;'>
         <tr>
            <td>
               <img src='cid:Header-vCheck' alt='vCheck' />
            </td>
            <td style='width: 171px'>
               <img src='cid:Header-VMware' alt='VMware' />
            </td>
         </tr>
      </table>
      <div style='height: 10px; font-size: 10px;'>&nbsp;</div>
      <table width='100%'><tr><td style='background-color: #0A77BA; border: 1px solid #0A77BA; vertical-align: middle; height: 30px; text-indent: 10px; font-family: Tahoma, sans-serif; font-weight: bold; font-size: 8pt; color: #FFFFFF;'>_HEADER_</td></tr></table>
      <div>_TOC_</div>
      _CONTENT_
   <!-- CustomHTMLClose -->
   <div style='height: 10px; font-size: 10px;'>&nbsp;</div>
   <table width='100%'><tr><td style='font-size:14px; font-weight:bold; height: 25px; text-align: center; vertical-align: middle; background-color:#0A77BA; color: white;'>vCheck v$($vCheckVersion) by <a href='http://virtu-al.net' sytle='color: white;'>Alan Renouf</a> generated on $($ENV:Computername) on $($Date.ToLongDateString()) at $($Date.ToLongTimeString())</td></tr></table>
   </body>
</html>
"@

$HTMLTemplate=@"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html><head><title>My Systems Report</title>
<style type="text/css">
<!--
body {
font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
}

    #report { width: 835px; }

    table{
       border-collapse: collapse;
       border: none;
       font: 10pt Verdana, Geneva, Arial, Helvetica, sans-serif;
       color: black;
       margin-bottom: 10px;
}
    table th {
       font-size: 12px;
		font:  Verdana, Geneva, Arial, Helvetica, sans-serif;
		font-weight: bold
       padding-left: 0px;
       padding-right: 20px;
       text-align: left;
}
    table td{
       font-size: 10px;
       padding-left: 0px;
       padding-right: 15px;
       text-align: left;
}



h2{ clear: both; font-size: 130%; }

h3{
       clear: both;
       font-size: 115%;
       margin-left: 20px;
       margin-top: 30px;
}

p{ margin-left: 20px; font-size: 12px; }

table.list{ float: left; }

    table.list td:nth-child(1){
       font-weight: bold;
       border-right: 1px grey solid;
       text-align: right;
}

table.list td:nth-child(2){ padding-left: 7px; }
table tr:nth-child(even) td:nth-child(even){ background: #CCCCCC; }
table tr:nth-child(odd) td:nth-child(odd){ background: #F2F2F2; }
table tr:nth-child(even) td:nth-child(odd){ background: #DDDDDD; }
table tr:nth-child(odd) td:nth-child(even){ background: #E5E5E5; }
div.column { width: 320px; float: left; }
div.first{ padding-right: 20px; border-right: 1px  grey solid; }
div.second{ margin-left: 30px; }
table{ margin-left: 20px; }
-->
</style>
</head>
<body>
"@


$HTMLEnd = @"
</div>
</body>
</html>
"@