
function Get-Docs {
    [CmdletBinding()]
    param (
    )
    
    begin {
        $DOCS_URI = "https://docs.microsoft.com/en-us/azure/azure-resource-manager/"
    }
    
    process {
        return $DOCS_URI
    }
    
    end {
    }
}