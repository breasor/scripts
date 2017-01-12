<#
.Synopsis
   Use as a template for loading XAML based GUIs.
.DESCRIPTION
   A template for use while developing XAML based GUIs for powershell scripts. Save XAML code to another file and use this to load and generate the objects
.PARAMETER
    xamlpath -The path to a file containing XAML gui design.
.PARAMETER
    design -A switch to output a table of the WPF objects creatd from loading the xaml file at xamlpath, for use in initial design process.
.EXAMPLE
    PS>. show-xaml -xamlpath .\xamlraw.ps1
    -builds the xaml into WPF GUI
.EXAMPLE
   PS>. show-xaml -xamlpath .\xamlraw.ps1 -design
   -builds the xaml into WPF GUI, and outputs a table of item names and values from the generated WPF GUI
#>
function Show-Xaml
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, helpmessage="path to XAML GUI code")]
        $xamlpath,
        [Parameter(helpmessage="output table of WPF GUI items created from xaml" )]
        [switch]$design
    )

    Begin {
        [void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
        [xml]$XAML = (get-content $xamlpath -ReadCount 0) -replace "x:Name", "Name"

        $reader=(New-Object System.Xml.XmlNodeReader $XAML)

        try{
            $Form=[Windows.Markup.XamlReader]::Load( $reader)
        }
        catch{
            Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."
            exit
        }

        $controls = $xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)-PassThru }
        if($design){
            write-output "Available items: "
            foreach($control in $controls){$control}
        }
        # If you have any controls/events you want to initiallize, place code here
    }

    Process {
        # Add Event bindings to code 


    }
    End{
        $form.ShowDialog()
    }
}