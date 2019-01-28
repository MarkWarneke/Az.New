
function Format-SchemaObject {
    param (
        # Schmea for format
        [Parameter(Mandatory)]
        [object[]]
        $item
    )
    foreach ($_item in $item) {

        if (! ($_item.Path -match 'schemas*')) {
            Continue
        }

        $apiVersion = ($_item.Path -split '/')[-2]

        $base64Content = (Invoke-RestMethod -Method Get -Uri $_item.git_url).content
        $content = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64Content))

        [PSCustomObject]@{
            Name       = $_item.name
            git_url    = $_item.git_url
            apiVersion = $apiVersion
            content    = $content
        }
    }
}
