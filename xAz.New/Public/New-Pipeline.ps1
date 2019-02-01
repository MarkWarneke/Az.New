function New-Pipeline {
    [CmdletBinding()]
    param (
        [string[]] $Path
    )

    begin {
    }

    process {
        # Modify [CmdletBinding()] to [CmdletBinding(SupportsShouldProcess=$true)]
        $paths = @()
        foreach ($aPath in $Path) {
            if (!(Test-Path -LiteralPath $aPath)) {
                $ex = New-Object System.Management.Automation.ItemNotFoundException "Cannot find path '$aPath' because it does not exist."
                $category = [System.Management.Automation.ErrorCategory]::ObjectNotFound
                $errRecord = New-Object System.Management.Automation.ErrorRecord $ex, 'PathNotFound', $category, $aPath
                $psCmdlet.WriteError($errRecord)
                continue
            }

            # Resolve any relative paths
            $paths += $psCmdlet.SessionState.Path.GetUnresolvedProviderPathFromPSPath($aPath)
        }

        foreach ($aPath in $paths) {
            if ($pscmdlet.ShouldProcess($aPath, 'Create Pipeline')) {
                $files = Get-xAzPipelineFiles
                $null = Copy-Item -Path $files -Destination $Path
            }
        }
    }

    end {
    }
}