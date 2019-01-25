# Dot source this script in any Pester test script that requires the module to be imported.

$ModuleManifestName = 'xAz.New.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

if (!$SuppressImportModule) {
    # -Scope Global is needed when running tests from inside of psake, otherwise
    # the module's functions cannot be found in the Az.New\ namespace
    Import-Module $ModuleManifestPath -Scope Global
}
