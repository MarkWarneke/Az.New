function Get-TemplateSchemaUri {
    [CmdletBinding()]
    param (
    )
    process {
        Get-xAzUri SCHEMA
    }
}