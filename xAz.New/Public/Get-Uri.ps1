function Get-Uri {
    <#
    .SYNOPSIS
    Returns a set of useful Azure URLs

    .DESCRIPTION
   Returns a set of useful Azure URLs

    .PARAMETER Type
    Filter list of URLs

    .EXAMPLE
   Get-xAzUri

    Name      URI
    ----      ---
    GUIDE     https://github.com/Azure/azure-quickstart-templates/tree/master/1-CONTRIBUTION-GUIDE
    DOCS      https://docs.microsoft.com/en-us/azure/azure-resource-manager/
    REFERENCE https://docs.microsoft.com/en-us/azure/templates/{0}/allversions
    SCHEMA    https://github.com/Azure/azure-resource-manager-schemas/tree/master/schemas
    #>

    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $Type
    )

    begin {
        $moduleFileList = $Local:MyInvocation.MyCommand.Module.FileList
        $UriFile = $moduleFileList[2]
        $Basedirectory = Split-Path $urifile -Parent
        $FileName = Split-path $UriFile -Leaf
        $URI_DATA = Import-LocalizedData -Basedirectory $Basedirectory -FileName $FileName
    }

    process {
        if ($Type) {
            foreach ($uri in $URI_DATA) {
                if ($Type -contains $uri.Name) {
                    $uri.URI
                }
            }
        }
        else {
            foreach ($uri in $URI_DATA) {
                [PSCustomObject]@{
                    Name = $uri.Name
                    URI  = $uri.Uri
                }
            }
        }
    }
}