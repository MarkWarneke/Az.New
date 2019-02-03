
function Get-Documentation {
    [CmdletBinding()]
    param (
    )
    process {
        Get-xAzUri DOCS
    }
}