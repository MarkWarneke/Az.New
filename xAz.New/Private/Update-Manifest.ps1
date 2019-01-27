function Update-Manifest {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [string] $DefaultCommandPrefix,
        [string[]] $Path
    )

    begin {
        $RequiredModuleSetting = "RequiredModules = @('Az')"
        $FileListSetting = "FileList = @('./Static/azuredeploy.json')"
        $DefaultCommandPrefixSetting = "DefaultCommandPrefix = '{0}'" -f $DefaultCommandPrefix
    }

    process {

        $paths = @()
        foreach ($aPath in $Path) {
            # Resolve any relative paths
            $paths += $psCmdlet.SessionState.Path.GetUnresolvedProviderPathFromPSPath($aPath)
        }

        foreach ($aPath in $paths) {
            if ($pscmdlet.ShouldProcess($aPath, 'Replace')) {
                Write-Verbose -Message "[$(Get-Date)] Update Manifest $aPath"

                $Manifest = Get-Content -Path $aPath -Raw -ErrorAction Stop
                # $Manifest = $Manifest.replace("# RequiredModules = @()", $RequiredModuleSetting)
                $Manifest = $Manifest.replace("# FileList = @()", $FileListSetting)
                $Manifest = $Manifest.replace("# DefaultCommandPrefix = ''", $DefaultCommandPrefixSetting)

                Set-Content -Value $Manifest -Path $aPath -Encoding UTF8 -PassThru
            }
        }


    }
}