


function Get-SchemaUri {
    [CmdletBinding()]
    param (
    )

    begin {
        $SCHEMA_URI = "https://github.com/Azure/azure-resource-manager-schemas/tree/master/schemas"
    }

    process {
        return $SCHEMA_URI
    }

    end {
    }
}