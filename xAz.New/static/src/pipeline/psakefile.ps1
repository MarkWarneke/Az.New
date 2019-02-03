<#
.SYNOPSIS
PSake makes variables declared here available in other scriptblocks

.DESCRIPTION
- Init: set location and enumerate environment details
- PrepareTest: [installs dependencies]
- Test
    - ModuleTest: Executes per module /test
    - UnitTest: Executes per module /test -Tag Unit
    - IntegrationTest: Executes per module /test/integration
PSake makes variables declared here available in other scriptblocks

.EXAMPLE

C:\PS> .\psakefile.ps1 -TaskList Test -Verbose
Run psake TaskLists named "Test"
#>

# Init some things
Properties {
    # Prepare the folder variables
    if (-not $ProjectRoot) {
        $ProjectRoot = $PSScriptRoot
    }

    $ModuleBase = @('.')
    Write-Verbose "$ModuleBase"

    $Timestamp = Get-Date -uformat "%Y%m%d-%H%M%S"
    Write-Verbose "$Timestamp"
    $separator = '----------------------------------------------------------------------'
    Write-Verbose "$separator"
}

Task Default -Depends Test

Task Init {
    Set-Location -Path $ProjectRoot

    # Install any dependencies required for the Init stage
    Invoke-PSDepend -Path $PSScriptRoot -Force -Import -Install -Tags 'Init'

    $separator
    'Other Environment Variables:'
    Get-ChildItem -Path ENV:
    "`n"

    $separator
    'PowerShell Details:'
    $PSVersionTable
    "`n"
}

Task PrepareTest -Depends Init {
    # Install any dependencies required for testing
    Invoke-PSDepend -Path $PSScriptRoot -Force -Import -Install -Tags 'Test'

    foreach ($module in $ModuleBase) {
        # Execute tests
        $moduleRoot = Join-Path -Path $ProjectRoot -ChildPath $module
        $testScriptsPath = Join-Path -Path $moduleRoot -ChildPath 'test'
        . Join-Path $testScriptsPath "Shared.Tests.ps1"
    }
}

Task Test -Depends ModuleTest, UnitTest, IntegrationTest

Task ModuleTest -Depends Init, PrepareTest {
    $separator

    foreach ($module in $ModuleBase) {
        # Execute tests
        $moduleRoot = Join-Path -Path $ProjectRoot -ChildPath $module
        $testScriptsPath = Join-Path -Path $moduleRoot -ChildPath 'test\Module'
        $testResultsFile = Join-Path -Path $ProjectRoot -ChildPath 'TestResults.module.xml'

        $pester = @{
            Script       = $testScriptsPath
            OutputFormat = 'NUnitXml'
            OutputFile   = $testResultsFile
            PassThru     = $true
            ExcludeTag   = 'Incomplete, Unit'
        }
        $null = Invoke-Pester @pester
    }

    "`n"
}

Task UnitTest -Depends Init, PrepareTest {
    $separator

    foreach ($module in $ModuleBase) {
        # Execute tests
        $moduleRoot = Join-Path -Path $ProjectRoot -ChildPath $module
        $testScriptsPath = Join-Path -Path $moduleRoot -ChildPath 'Test\Unit'
        $testResultsFile = Join-Path -Path $ProjectRoot -ChildPath 'TestResults.unit.xml'
        # $codeCoverageFile = Join-Path -Path $ProjectRoot -ChildPath 'CodeCoverage.xml'

        $pester = @{
            Script       = $testScriptsPath
            OutputFormat = 'NUnitXml'
            OutputFile   = $testResultsFile
            PassThru     = $true
            Tag          = 'Unit'
            ExcludeTag   = 'Incomplete'
            # CodeCoverage                 = $codeCoverageSource
            # CodeCoverageOutputFile       = $codeCoverageFile
            # CodeCoverageOutputFileFormat = 'JaCoCo'
        }
        $null = Invoke-Pester @pester

    }
    "`n"
}

Task IntegrationTest -Depends Init, PrepareTest {
    $separator

    foreach ($module in $ModuleBase) {
        # Execute tests
        $moduleRoot = Join-Path -Path $ProjectRoot -ChildPath $module
        $testScriptsPath = Join-Path -Path $moduleRoot -ChildPath 'Test\Integration'
        $testResultsFile = Join-Path -Path $ProjectRoot -ChildPath 'TestResults.integration.xml'

        if (Test-Path $testScriptsPath) {
            $pester = @{
                Script       = $testScriptsPath
                OutputFormat = 'NUnitXml'
                OutputFile   = $testResultsFile
                PassThru     = $true
                ExcludeTag   = 'Incomplete'
            }
            $null = Invoke-Pester @pester
        }
    }

    "`n"
}

Task Build -Depends Init {
    $separator

    # Install any dependencies required for the Build stage
    Invoke-PSDepend -Path $PSScriptRoot -Force -Import -Install -Tags 'Build'

    # New-MarkdownHelp -Module $ModuleName -OutputFolder (Join-Path -Path $ProjectRoot -ChildPath $DocsFolder) -Force

    # Prepare external help
    'Building external help file'
    New-ExternalHelp -Path (Join-Path -Path $ProjectRoot -ChildPath 'docs\en-US') -OutputPath . -Force

}

<#
    .SYNOPSIS
        Generate a new version number.
#>
function Get-VersionNumber {
    [CmdLetBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ManifestPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Build
    )

    # Get version number from the existing manifest
    $manifestContent = Get-Content -Path $ManifestPath -Raw
    $regex = '(?<=ModuleVersion\s+=\s+'')(?<ModuleVersion>.*)(?='')'
    $matches = @([regex]::matches($manifestContent, $regex, 'IgnoreCase'))
    $version = $null

    if ($matches) {
        $version = $matches[0].Value
    }

    # Determine the new version number
    $versionArray = $version -split '\.'
    $newVersion = ''

    foreach ($ver in (0..2)) {
        $sem = $versionArray[$ver]

        if ([String]::IsNullOrEmpty($sem)) {
            $sem = '0'
        }

        $newVersion += "$sem."
    }

    $newVersion += $Build
    return $newVersion
}

<#
    .SYNOPSIS
        Safely execute a Git command.
#>
function Invoke-Git {
    [CmdLetBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String[]]
        $GitParameters
    )

    try {
        "Executing 'git $($GitParameters -join ' ')'"
        exec { & git $GitParameters }
    }
    catch {
        Write-Warning -Message $_
    }
}