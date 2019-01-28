function Get-Guide {
    [CmdletBinding()]
    param (
    )

    begin {
        $GUIDE_URI = "https://github.com/Azure/azure-quickstart-templates/tree/master/1-CONTRIBUTION-GUIDE"
    }

    process {
        return $GUIDE_URI
    }

    end {
    }
}