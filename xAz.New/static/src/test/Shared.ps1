# Dot source this script in any Pester test script that requires the module to be imported.

$ModuleManifestName = '<%=$PLASTER_PARAM_ModuleName%>.psd1'

$ModuleBase = Split-Path -Parent $MyInvocation.MyCommand.Path

if ((Split-Path $ModuleBase -Leaf) -eq 'Module') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}

if ((Split-Path $ModuleBase -Leaf) -eq 'Test') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}

$ModuleManifestPath = Join-Path $ModuleBase $ModuleManifestName

if (!$SuppressImportModule) {
    # -Scope Global is needed when running tests from inside of psake, otherwise
    # the module's functions cannot be found in the <%=$PLASTER_PARAM_ModuleName%>\ namespace
    Import-Module $ModuleManifestPath -Scope Global
}