

function Test-Uri {
    [CmdletBinding()]
    param (
        $TemplateUri
    )
    process {
        return ('http:' -match $TemplateUri -or 'www' -match $TemplateUri)
    }
}