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