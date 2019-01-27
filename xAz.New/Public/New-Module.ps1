function New-Module {
    <#
    .SYNOPSIS
     Create a PowerShell module in specified path.

    .DESCRIPTION
    Create a PowerShell module in specified path.
    It can be used to deploy Azure Resource Manager Templates, if TemplateUri is provided
    The scaffolding is based on `Plaster`, it generates tests and best practices checks for Azure Resource Manager Templates.

    .PARAMETER ModuleName
    Name of the new PowerShell module

    .PARAMETER ModuleDescription
    Description of the new PowerShell module

    .PARAMETER Path
    Location where to generate PowerShell module files and folders

    .PARAMETER DefaultCommandPrefix
    DefaultCommandPrefix in PowerShell Manifest file. Is used to avoid Namespace.
    The command will be prefixed with the DefaultCommandPrefix.

    .PARAMETER EMail
    Contact E-Mail Address for Module Manifest

    .PARAMETER CompanyName
    Company Name for Module Manifest

    .PARAMETER AuthorName
    Author Name for Manifest, will use local username if empty

    .PARAMETER TemplateUri
    Uri to an ARM template to be used instead of blank

    .PARAMETER Prefix
    Prefix of the module, not the DefaultCommandPrefix.
    Prefix will be prefixed of the module name to avoid Namespace conflicts.

    .PARAMETER WhatIf
    Dry run

    .PARAMETER Confirm
    Prompt user confirmation

    .EXAMPLE
    New-xAzModule -ModuleName "KeyVault" -ModuleDescription "Azure Tool Module to deploy Azure KeyVault" -Path "C:/temp" -DefaultCommandPrefix "xAzKV" -Email "warneke.mark@gmail.com" -CompanyName "microsoft"

    Directory: C:\temp\xAz.KeyVault

    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    d-----       27.01.2019     15:51                .vscode
    d-----       27.01.2019     15:51                Classes
    d-----       27.01.2019     15:51                docs
    d-----       27.01.2019     15:51                Localization
    d-----       27.01.2019     15:51                Private
    d-----       27.01.2019     15:51                Public
    d-----       27.01.2019     15:51                Static
    d-----       27.01.2019     15:51                Test
    -a----       27.01.2019     15:51           7670 CommonResourceHelper.psm1
    -a----       27.01.2019     15:51             13 KeyVaultSecrets.psd1
    -a----       27.01.2019     15:51           3908 xAz.KeyVault.psd1
    -a----       27.01.2019     14:27           1282 xAz.KeyVault.psm1




    .EXAMPLE
    New-xAzModule -ModuleName 'Cosmos' -ModuleDescription 'Module to deploy Cosmos' -Path $Path -DefaultCommandPrefix = "xAzCosmos" -EMail = "mark.warneke@gmail.com" -CompanyName = "Microsoft" -AuthorName = "Mark" -TemplateUri "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-cosmosdb-create-arm-template/azuredeploy.json

    Generates files into $Path
    Downloads ARM tmeplate from URI

    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory)]
        [string] $ModuleName,

        [Parameter(Mandatory)]
        [string] $ModuleDescription,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter()]
        [string] $DefaultCommandPrefix = "xAz",

        [Parameter()]
        [string] $EMail,

        [Parameter()]
        [string] $CompanyName,

        [Parameter()]
        [string] $AuthorName = $env:USERNAME,

        [Parameter()]
        [string] $TemplateUri,

        [Parameter()]
        [string] $Prefix = "xAz."
    )

    $TemplatePath = Get-xAzManifest
    $NewModuleName = "{0}{1}" -f $Prefix, $ModuleName
    $DestinationPath = (Join-Path $Path $NewModuleName)  # Must be named exactly like ModuleName for tests

    $plaster = @{
        AuthorName        = $AuthorName
        CompanyName       = $CompanyName
        ModuleName        = $NewModuleName
        ModuleDescription = $ModuleDescription
        Version           = "0.0.1"
        EMail             = $EMail
        Prefix            = $DefaultCommandPrefix
    }

    if (!(Test-Path -LiteralPath $DestinationPath)) {
        # Resolve any relative paths
        $DestinationPath = $psCmdlet.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DestinationPath)
        $TemplateDirectory = Split-Path $TemplatePath -Parent

        if ($pscmdlet.ShouldProcess($DestinationPath, 'Invoke-Plaster')) {
            Write-Verbose -Message "[$(Get-Date)] Create folder"
            New-Item -ItemType Directory -Path $DestinationPath
            Write-Verbose -Message "[$(Get-Date)] Generate Module"
            $plaster = Invoke-Plaster -DestinationPath $DestinationPath -TemplatePath $TemplateDirectory @plaster -PassThru

            $GeneratedModuleManifestFile = Get-ChildItem -Path $DestinationPath -Name "$NewModuleName.psd1" -ErrorAction Stop
            $null = Update-Manifest -Path $GeneratedModuleManifestFile.PSPath -DefaultCommandPrefix $DefaultCommandPrefix


            $null = Update-Template -Path $DestinationPath -TemplateUri $TemplateUri

            $plaster
        }
    }
    else {
        Write-Error ("New Module Path already exsists! {0} not created" -f $NewModuleName)
    }
}
