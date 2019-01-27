
function Test-Url {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Url
    Parameter description

    .EXAMPLE
    An example

    .LINK
    https://docs.microsoft.com/en-us/dotnet/api/system.uri.iswellformeduristring?redirectedfrom=MSDN&view=netframework-4.7.2#System_Uri_IsWellFormedUriString_System_String_System_UriKind_
    #>

    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $true)]
        [String] $Url
    )

    Process {
        if ([system.uri]::IsWellFormedUriString($Url, [System.UriKind]::Absolute)) {
            Write-Verbose -Message "[$(Get-Date)] URL found"
            $true
        }
        else {
            Write-Verbose -Message "[$(Get-Date)] false"
            $false
        }
    }
}