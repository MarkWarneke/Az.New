# xAz.New

Framework for Azure Resource Manager Deployments based on ARM-Templates) Infrastructure as code. PowerShell Core.

The module will create a PowerShell module in specified path.
It can be used to deploy Azure Resource Manager Templates.
The scaffolding is based on `Plaster`, it generates tests and best practices checks for Azure Resource Manager Templates.

```PowerShell
# .\Examples\createBasic.ps1

$input = @{
    ModuleName           = 'KeyVault'
    ModuleDescription    = 'Function to deploy KeyVault'
    Path                 = $Path
    DefaultCommandPrefix = "xAzKV"
    EMail                = "mark.warneke@gmail.com"
    CompanyName          = "Microsoft"
    AuthorName           = "Mark"
}
$Module = New-xAzModule @Input

<#
    Directory: C:\temp\xAzKVKeyVault


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       27.01.2019     14:36                .vscode
d-----       27.01.2019     14:36                Classes
d-----       27.01.2019     14:36                docs
d-----       27.01.2019     14:36                Localization
d-----       27.01.2019     14:36                Private
d-----       27.01.2019     14:36                Public
d-----       27.01.2019     14:36                Static
d-----       27.01.2019     14:36                Test
-a----       27.01.2019     14:36           7670 CommonResourceHelper.psm1
-a----       27.01.2019     14:36             13 KeyVaultSecrets.psd1
-a----       27.01.2019     14:36           3987 xAzKVKeyVault.psd1
-a----       27.01.2019     14:27           1282 xAzKVKeyVault.psm1
#>

Import-Module C:\temp\xAzKVKeyVault
Get-Command -Module xAzKVKeyVault

<#
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-Name                                           0.0.1      xAzKVKeyVault
Function        Get-Secret                                         0.0.1      xAzKVKeyVault
Function        Get-Template                                       0.0.1      xAzKVKeyVault
Function        New-Deployment                                     0.0.1      xAzKVKeyVault
#>

# Edit the functions
# $Name = Get-xAzKVKeyVaultName -Environment p
# New-xAzKVKeyVaultDeployment -ResourceName $Name
```

## Introduction

- [Documentation](xAz.New/docs/en-US)
- [Examples](Examples)
- [Wiki](https://github.com/mark-mit-k/Az.New/wiki)

## Installation

[Installation Docs](xAz.New/docs/en-US/InstallNotes.md)

## Release

[Release Notes](xAz.New/docs/en-US/ReleaseNotes.md)

## Dependencies

xAz.New Module

- [Plaster](https://github.com/PowerShell/Plaster)
- [Pester](https://github.com/Pester/Pester)
- [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)

### Build

for clean Build additionally [PSake](https://github.com/psake/psake)