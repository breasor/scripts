# Filters
filter timestamp {"$(Get-Date -Format G): $_"}

# Script Module for Company Functions
Function Get-ScriptDirectory {
    # $MyInvocation is an Automatic variable that contains runtime details and
    # we can use this to get information about where the file is run from.
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    Split-Path $Invocation.MyCommand.Path
}

Get-ChildItem (Get-ScriptDirectory) -Recurse `
    | Where-Object { $_.Name -like "func_*" } `
| %{
    . $_.FullName
}


Get-ChildItem (Get-ScriptDirectory) -Recurse `
    | Where-Object { $_.Name -like "rc_*" } `
| %{
    . $_.FullName
}