
function Get-BestPractice {
    [CmdletBinding()]
    param (
    )
    process {
        Get-xAzUri BEST_PRACTICES
    }
}