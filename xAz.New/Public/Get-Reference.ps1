


function Get-Reference {
    [CmdletBinding()]
    param (
        # Resource Types to get URI
        [Parameter(Mandatory)]
        [string[]]
        $ProviderNamespace
    )

    process {
        foreach ($type in $ProviderNamespace) {
            $uri = (get-xAzUri REFERENCE) -f $type
            if (Test-UriStatus $uri) {
                $uri
            }
            else {
                Write-Error "ResourceType $type not found"

            }
        }
    }
}

