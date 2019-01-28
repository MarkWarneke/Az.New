function Get-Schema {
    [CmdletBinding()]
    param (
        # Provide ProviderNamespace from Get-AzResourceProvider
        [Parameter(Mandatory = $true)]
        [string]
        $ProviderNamespace,
        [switch]
        $latest = $false
    )

    begin {
        $api = 'https://api.github.com/'
        $organization = 'Azure'
        $repository = 'azure-resource-manager-schemas'
    }

    process {
        $provider = $ProviderNamespace
        $fileName = '{0}.json' -f $provider
        $searchQuery = ("search/code?q=org:{0}+repo:{1}+filename:{2}" -f $organization, $repository, $fileName)

        $URI = $api + $searchQuery
        try {
            Write-Verbose "[$(Get-Date) Get $URI]"
            $api = Invoke-RestMethod -Method Get -Uri $URI
        }
        catch {
            throw $_
        }

        if ($api.items) {
            if ($latest) {
                # TODO: refactor
                $schemas = Format-SchemaObject $api.items
                if ( ! $schemas) {
                    throw "No schema found $provider"
                }
                elseif ($schemas.Length -eq 1) {
                    $schemas
                }
                else {
                    ($schemas)[-1]
                }
            }
            else {
                Format-SchemaObject $api.items
            }
        }
        else {
            Write-Error "No $ProviderNameSpace Schema found"
        }


    }

    end {
    }
}
