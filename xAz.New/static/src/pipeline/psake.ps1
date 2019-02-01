[CmdletBinding()]
param (
    [Parameter()]
    [System.String[]]
    $TaskList = 'Default',

    [Parameter()]
    [System.Collections.Hashtable]
    $Parameters,

    [Parameter()]
    [System.Collections.Hashtable]
    $Properties
)

Write-Verbose -Message ('Beginning ''{0}'' process...' -f ($TaskList -join ','))

# Bootstrap the environment
$null = Get-PackageProvider -Name NuGet -ForceBootstrap
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser

$module = Get-Module psake -ListAvailable
if ($module) {
    Import-Module psake
}
else {
    Install-Module psake -Force -Verbose -Scope CurrentUser
}

# Execute the PSake tasts from the psakefile.ps1
Invoke-Psake -buildFile (Join-Path -Path $PSScriptRoot -ChildPath 'psakefile.ps1') -nologo @PSBoundParameters

exit ( [int]( -not $psake.build_success ) )