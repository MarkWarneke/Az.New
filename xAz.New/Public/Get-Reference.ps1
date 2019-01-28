


function Get-Reference {
    [CmdletBinding()]
    param (
        # Resource Types to get URI
        [Parameter(Mandatory)]
        [string[]]
        $ProviderNamespace
    )

    begin {
        $REFERENCE_URI = "https://docs.microsoft.com/en-us/azure/templates/{0}/allversions"
    }

    process {
        foreach ($type in $ProviderNamespace) {
            $uri = $REFERENCE_URI -f $type
            if (Test-UriStatus $uri) {
                $uri
            }
            else {
                Write-Error "ResourceType $type not found"

            }
        }
    }

    end {
    }
}

