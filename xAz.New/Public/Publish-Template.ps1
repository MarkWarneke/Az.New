function Publish-Template {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Name of storage account
        [Parameter(Mandatory,
            HelpMessage = "Name of stroage account"
        )]
        [string[]] $StorageAccountName,

        # Path to template files
        [Parameter(
            Mandatory,
            HelpMessage = "Path to tempalte files"
        )]
        [string] $Path
    )

    begin {
        $containerName = 'templates'

    }

    process {
        foreach ($storageAccount in $StorageAccountName) {

            $resource = Get-AzureStorageAccount -StorageAccountName $storageAccount
            $ctx = $resource.Context

            $container = Get-AzureStorageContainer -Name $containerName -Context $ctx
            if (-not ($container)) {
                if ($pscmdlet.ShouldProcess($storageAccount, 'Create Container')) {
                    New-AzureStorageContainer -Name $containerName -Context $ctx -Permission blob
                }
            }

            Push-Location $Path
            $RelativePath = Get-Item $file.FullName | Resolve-Path -Relative
            foreach ($file in (Get-ChildItem -Path $Path -Recurse)) {
                if ($pscmdlet.ShouldProcess($storageAccount, 'Upload', $RelativePath)) {
                    Set-AzureStorageBlobContent -File $file.FullName -Container $containerName -Blob $RelativePath -Context $ctx
                }
            }
            Pop-Location
        }
    }

    end {
    }
}