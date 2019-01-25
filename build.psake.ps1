#Requires -Modules psake

##############################################################################
# DO NOT MODIFY THIS FILE!  Modify build.settings.ps1 instead.
##############################################################################

##############################################################################
# This is the PowerShell Module psake build script. It defines the following tasks:
#
# Clean, Build, Sign, BuildHelp, Install, Test and Publish.
#
# The default task is Build.  This task copies the appropriate files from the
# $SrcRootDir under the $OutDir.  Later, other tasks such as Sign and BuildHelp
# will further modify the contents of $OutDir and add new files.
#
# The Sign task will only sign scripts if the $SignScripts variable is set to
# $true.  A code-signing certificate is required for this task to complete.
#
# The BuildHelp task invokes platyPS to generate markdown files from
# comment-based help for your exported commands.  platyPS then generates
# a help file for your module from the markdown files.
#
# The Install task simplies copies the module folder under $OutDir to your
# profile's Modules folder.
#
# The Test task invokes Pester on the $TestRootDir.
#
# The Publish task uses the Publish-Module command to publish
# to either the PowerShell Gallery (the default) or you can change
# the $PublishRepository property to the name of an alternate repository.
# Note: the Publish task requires that the Test task execute without failures.
#
# You can exeute a specific task, such as the Test task by running the
# following command:
#
# PS C:\> invoke-psake build.psake.ps1 -taskList Test


###############################################################################
# Dot source the user's customized properties and extension tasks.
###############################################################################
. $PSScriptRoot\build.settings.ps1

###############################################################################
# Private properties.
###############################################################################
Properties {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ModuleOutDir = "$OutDir\$ModuleName"

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $UpdatableHelpOutDir = "$OutDir\UpdatableHelp"

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $SharedProperties = @{}

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $LineSep = "-" * 78
}

###############################################################################
# Core task implementations. Avoid modifying these tasks.
###############################################################################
Task default -depends Build

Task Init -requiredVariables OutDir {
    if (!(Test-Path -LiteralPath $OutDir)) {
        New-Item $OutDir -ItemType Directory -Verbose:$VerbosePreference > $null
    }
    else {
        Write-Verbose "$($psake.context.currentTaskName) - directory already exists '$OutDir'."
    }
}

Task Clean -depends Init -requiredVariables OutDir {
    # Maybe a bit paranoid but this task nuked \ on my laptop. Good thing I was not running as admin.
    if ($OutDir.Length -gt 3) {
        Get-ChildItem $OutDir | Remove-Item -Recurse -Force -Verbose:$VerbosePreference
    }
    else {
        Write-Verbose "$($psake.context.currentTaskName) - `$OutDir '$OutDir' must be longer than 3 characters."
    }
}

Task StageFiles -depends Init, Clean, BeforeStageFiles, CoreStageFiles, AfterStageFiles {
}

Task CoreStageFiles -requiredVariables ModuleOutDir, SrcRootDir {
    if (!(Test-Path -LiteralPath $ModuleOutDir)) {
        New-Item $ModuleOutDir -ItemType Directory -Verbose:$VerbosePreference > $null
    }
    else {
        Write-Verbose "$($psake.context.currentTaskName) - directory already exists '$ModuleOutDir'."
    }

    Copy-Item -Path $SrcRootDir\* -Destination $ModuleOutDir -Recurse -Exclude $Exclude -Verbose:$VerbosePreference
}

Task Build -depends Init, Clean, BeforeBuild, StageFiles, Analyze, AfterBuild {
}

Task Analyze -depends StageFiles `
    -requiredVariables ModuleOutDir, ScriptAnalysisEnabled, ScriptAnalysisFailBuildOnSeverityLevel, ScriptAnalyzerSettingsPath {
    if (!$ScriptAnalysisEnabled) {
        "Script analysis is not enabled. Skipping $($psake.context.currentTaskName) task."
        return
    }

    if (!(Get-Module PSScriptAnalyzer -ListAvailable)) {
        "PSScriptAnalyzer module is not installed. Skipping $($psake.context.currentTaskName) task."
        return
    }

    "ScriptAnalysisFailBuildOnSeverityLevel set to: $ScriptAnalysisFailBuildOnSeverityLevel"

    $analysisResult = Invoke-ScriptAnalyzer -Path $ModuleOutDir -Settings $ScriptAnalyzerSettingsPath -Recurse -Verbose:$VerbosePreference
    $analysisResult | Format-Table
    switch ($ScriptAnalysisFailBuildOnSeverityLevel) {
        'None' {
            return
        }
        'Error' {
            Assert -conditionToCheck (
                ($analysisResult | Where-Object Severity -eq 'Error').Count -eq 0
            ) -failureMessage 'One or more ScriptAnalyzer errors were found. Build cannot continue!'
        }
        'Warning' {
            Assert -conditionToCheck (
                ($analysisResult | Where-Object {
                        $_.Severity -eq 'Warning' -or $_.Severity -eq 'Error'
                    }).Count -eq 0) -failureMessage 'One or more ScriptAnalyzer warnings were found. Build cannot continue!'
        }
        default {
            Assert -conditionToCheck (
                $analysisResult.Count -eq 0
            ) -failureMessage 'One or more ScriptAnalyzer issues were found. Build cannot continue!'
        }
    }
}

Task BuildHelp -depends Build, BeforeBuildHelp, GenerateMarkdown, GenerateHelpFiles, AfterBuildHelp {
}

Task GenerateMarkdown -requiredVariables DefaultLocale, DocsRootDir, ModuleName, ModuleOutDir {
    if (!(Get-Module platyPS -ListAvailable)) {
        "platyPS module is not installed. Skipping $($psake.context.currentTaskName) task."
        return
    }

    $moduleInfo = Import-Module $ModuleOutDir\$ModuleName.psd1 -Global -Force -PassThru

    try {
        if ($moduleInfo.ExportedCommands.Count -eq 0) {
            "No commands have been exported. Skipping $($psake.context.currentTaskName) task."
            return
        }

        if (!(Test-Path -LiteralPath $DocsRootDir)) {
            New-Item $DocsRootDir -ItemType Directory > $null
        }

        if (Get-ChildItem -LiteralPath $DocsRootDir -Filter *.md -Recurse) {
            Get-ChildItem -LiteralPath $DocsRootDir -Directory | ForEach-Object {
                Update-MarkdownHelp -Path $_.FullName -Verbose:$VerbosePreference > $null
            }
        }

        # ErrorAction set to SilentlyContinue so this command will not overwrite an existing MD file.
        New-MarkdownHelp -Module $ModuleName -Locale $DefaultLocale -OutputFolder $DocsRootDir\$DefaultLocale `
            -WithModulePage -ErrorAction SilentlyContinue -Verbose:$VerbosePreference > $null
    }
    finally {
        Remove-Module $ModuleName
    }
}

Task GenerateHelpFiles -requiredVariables DocsRootDir, ModuleName, ModuleOutDir, OutDir {
    if (!(Get-Module platyPS -ListAvailable)) {
        "platyPS module is not installed. Skipping $($psake.context.currentTaskName) task."
        return
    }

    if (!(Get-ChildItem -LiteralPath $DocsRootDir -Filter *.md -Recurse -ErrorAction SilentlyContinue)) {
        "No markdown help files to process. Skipping $($psake.context.currentTaskName) task."
        return
    }

    $helpLocales = (Get-ChildItem -Path $DocsRootDir -Directory).Name

    # Generate the module's primary MAML help file.
    foreach ($locale in $helpLocales) {
        New-ExternalHelp -Path $DocsRootDir\$locale -OutputPath $ModuleOutDir\$locale -Force `
            -ErrorAction SilentlyContinue -Verbose:$VerbosePreference > $null
    }
}

Task BuildUpdatableHelp -depends BuildHelp, BeforeBuildUpdatableHelp, CoreBuildUpdatableHelp, AfterBuildUpdatableHelp {
}


###############################################################################
# Helper functions
###############################################################################

function PromptUserForCredentialAndStorePassword {
    [Diagnostics.CodeAnalysis.SuppressMessage("PSProvideDefaultParameterValue", '')]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $DestinationPath,

        [Parameter(Mandatory)]
        [string]
        $Message,

        [Parameter(Mandatory, ParameterSetName = 'SaveSetting')]
        [string]
        $Key
    )

    $cred = Get-Credential -Message $Message -UserName "ignored"
    if ($DestinationPath) {
        SetSetting -Key $Key -Value $cred.Password -Path $DestinationPath
    }

    $cred
}

function AddSetting {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSShouldProcess', '', Scope = 'Function')]
    param(
        [Parameter(Mandatory)]
        [string]$Key,

        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [object]$Value
    )

    switch ($type = $Value.GetType().Name) {
        'securestring' { $setting = $Value | ConvertFrom-SecureString }
        default { $setting = $Value }
    }

    if (Test-Path -LiteralPath $Path) {
        $storedSettings = Import-Clixml -Path $Path
        $storedSettings.Add($Key, @($type, $setting))
        $storedSettings | Export-Clixml -Path $Path
    }
    else {
        $parentDir = Split-Path -Path $Path -Parent
        if (!(Test-Path -LiteralPath $parentDir)) {
            New-Item $parentDir -ItemType Directory > $null
        }

        @{$Key = @($type, $setting)} | Export-Clixml -Path $Path
    }
}

function GetSetting {
    param(
        [Parameter(Mandatory)]
        [string]$Key,

        [Parameter(Mandatory)]
        [string]$Path
    )

    if (Test-Path -LiteralPath $Path) {
        $securedSettings = Import-Clixml -Path $Path
        if ($securedSettings.$Key) {
            switch ($securedSettings.$Key[0]) {
                'securestring' {
                    $value = $securedSettings.$Key[1] | ConvertTo-SecureString
                    $cred = New-Object -TypeName PSCredential -ArgumentList 'jpgr', $value
                    $cred.GetNetworkCredential().Password
                }
                default {
                    $securedSettings.$Key[1]
                }
            }
        }
    }
}

function SetSetting {
    param(
        [Parameter(Mandatory)]
        [string]$Key,

        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [object]$Value
    )

    if (GetSetting -Key $Key -Path $Path) {
        RemoveSetting -Key $Key -Path $Path
    }

    AddSetting -Key $Key -Value $Value -Path $Path
}

function RemoveSetting {
    param(
        [Parameter(Mandatory)]
        [string]$Key,

        [Parameter(Mandatory)]
        [string]$Path
    )

    if (Test-Path -LiteralPath $Path) {
        $storedSettings = Import-Clixml -Path $Path
        $storedSettings.Remove($Key)
        if ($storedSettings.Count -eq 0) {
            Remove-Item -Path $Path
        }
        else {
            $storedSettings | Export-Clixml -Path $Path
        }
    }
    else {
        Write-Warning "The build setting file '$Path' has not been created yet."
    }
}