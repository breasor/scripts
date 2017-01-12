function Remove-StringLatinCharacters
{
<#
.SYNOPSIS
    Function to remove diacritics from a string
.PARAMETER String
	Specifies the String that will be processed
.EXAMPLE
    Remove-StringLatinCharacters -String "L’æuvre d’art, c’est une idée qu’on exagére"
    L'auvre d'art, c'est une idee qu'on exagere
.EXAMPLE
    Foreach ($file in (Get-ChildItem c:\test\*.txt))
    {
        # Get the content of the current file and remove the diacritics
        $Content = Get-content $file | Remove-StringLatinCharacters
    
        # Overwrite the current file with the new content
        $Content | Set-Content $file
    }
    Remove diacritics from multiple files
#>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)]
	    [System.String[]]$String
    )
    PROCESS {
    foreach ($stringValue in $String)
    {
        Write-Verbose -Message "$StringValue"
        Try {
            [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
        }
        Catch {
            Write-Error -Message $Error[0].Exception.Message
        }
    }
    }
}

