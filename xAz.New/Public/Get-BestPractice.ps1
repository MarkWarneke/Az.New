
function Get-BestPratice {
    [CmdletBinding()]
    param (
    )
    process {
        Get-xAzUri BEST_PRACTICES
    }
}