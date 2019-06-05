<#
    .SYNOPSIS
    Create a PowerShell tool module for customer Azure Resource Manager template, example like KeyVault

    .DESCRIPTION
    Create a PowerShell tool module for Azure Resource Manager Tempalte Deployment
    The module is located in $Path, or by default in "C:\temp".
    After the scaffolding of the module it will open the explorer
    Will wait for the users input to delete the newly create folder structure.

    # Usage
    Import-Module C:\temp\xAz.Cosmos\xAz.KeyVault.psd1
    Get-Command -Module xAz.KeyVault

    $Name = Get-xAzKVName -Environment P
    New-xAzKVDeployment -ResourceName $Name -ResourceGroupName $ResourceGroupName

    .EXAMPLE
    createBasic.ps1

    Directory: C:\temp

    Mode                LastWriteTime         Length Name
    d-----       27.01.2019     16:14                xAz.KeyVault
    Destination path: C:\temp\xAz.KeyVault

    TemplatePath    : C:\dev\Github\Az.New\xAz.New\static
    DestinationPath : C:\temp\xAz.KeyVault
    Success         : True
    TemplateType    : Unspecified
    CreatedFiles    : {C:\temp\xAz.KeyVault\xAz.KeyVault.psd1, C:\temp\xAz.KeyVault\xAz.KeyVault.psm1, C:\temp\xAz.KeyVault\Static\azuredeploy.json, C:\temp\xAz.Cosmos\Static\azuredeploy.parameters.json...}
    UpdatedFiles    : {}
    MissingModules  : {Az}
    OpenFiles       : {}


#>
param(
    # Local path where module should be created
    [Parameter(HelpMessage = "Local path where module should be created")]
    $Path = "C:\temp"
)

# Import xAz.New module
Import-Module (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "xAz.New/xAz.New.psd1") -Force

# Specify parameters
$input = @{
    ModuleName           = 'KeyVault'
    Description          = 'Function to deploy KeyVault'
    Path                 = $Path
    DefaultCommandPrefix = "xAzKV"
    EMail                = "mark.warneke@gmail.com"
    CompanyName          = "Microsoft"
    AuthorName           = "Mark"
}
# Create new module
$Module = New-xAzModule @Input

# Print to screen
$Module

# Open file explorer
Invoke-Item $Module.DestinationPath

# Remove created module - Ask for confirmation
Remove-Item -Path $Module.DestinationPath -Recurse -Force -Confirm