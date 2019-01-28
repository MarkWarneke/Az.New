
function Get-BestPratice {
    [CmdletBinding()]
    param (
    )

    begin {
        $BEST_PRACTICES_URI = "https://github.com/Azure/azure-quickstart-templates/blob/master/1-CONTRIBUTION-GUIDE/best-practices.md#best-practices"
    }

    process {
        return $BEST_PRACTICES_URI
    }

    end {
    }
}