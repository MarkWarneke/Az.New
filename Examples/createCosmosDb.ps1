<#
    .SYNOPSIS
    Create a PowerShell tool module for Azure Cosmos DB based on azure-quickstart-template ARM template

    .DESCRIPTION
    Create a PowerShell tool module for Azure Cosmos DB based on azure-quickstart-template ARM template
    Downloads the ARM template from "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-cosmosdb-create-arm-template/azuredeploy.json"
    The module is located in $Path, or by default in "C:\temp".
    After the scaffolding of the module it will open the explorer
    Will wait for the users input to delete the newly create folder structure.

    # Usage
    Import-Module C:\temp\xAz.Cosmos\xAz.Cosmos.psd1
    Get-Command -Module xAz.Cosmos

    $Name = Get-xAzCosmosName -Environment P
    New-xAzCosmosDeployment -ResourceName $Name -ResourceGroupName $ResourceGroupName

    .EXAMPLE
    createCosmosDb.ps1

    Directory: C:\temp

    Mode                LastWriteTime         Length Name
    d-----       27.01.2019     16:14                xAz.Cosmos
    Destination path: C:\temp\xAz.Cosmos

    TemplatePath    : C:\dev\Github\Az.New\xAz.New\static
    DestinationPath : C:\temp\xAz.Cosmos
    Success         : True
    TemplateType    : Unspecified
    CreatedFiles    : {C:\temp\xAz.Cosmos\xAz.Cosmos.psd1, C:\temp\xAz.Cosmos\xAz.Cosmos.psm1, C:\temp\xAz.Cosmos\Static\azuredeploy.json, C:\temp\xAz.Cosmos\Static\azuredeploy.parameters.json...}
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
    ModuleName           = 'Cosmos'
    ModuleDescription    = 'Function to deploy Cosmos Db'
    Path                 = $Path
    DefaultCommandPrefix = "xAzCosmos"
    EMail                = "mark.warneke@gmail.com"
    CompanyName          = "Microsoft"
    AuthorName           = "Mark"
    TemplateUri          = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-cosmosdb-create-arm-template/azuredeploy.json"
}
# Create new module
$Module = New-xAzModule @Input

# Print to screen
$Module

# Open file explorer
Invoke-Item $Module.DestinationPath

# Remove created module - Ask for confirmation
Remove-Item -Path $Module.DestinationPath -Recurse -Force -Confirm