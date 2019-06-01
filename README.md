# xAz.New

Framework for Azure Resource Manager Deployments based on ARM-Templates) Infrastructure as code. PowerShell Core.

The module will create a PowerShell module in specified path.
It can be used to deploy Azure Resource Manager Templates.
The scaffolding is based on `Plaster`, it generates tests and best practices checks for Azure Resource Manager Templates.

See [Examples](Examples) e.g. `createBasic.ps1`

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
#>

Import-Module C:\temp\xAz.KeyVault\xAz.KeyVault.psd1
Get-Command -Module xAz.KeyVault

<#
    CommandType     Name                                               Version    Source
    -----------     ----                                               -------    ------
    Function        Get-xAzKVName                                      0.0.1      xAz.KeyVault
    Function        Get-xAzKVSecret                                    0.0.1      xAz.KeyVault
    Function        Get-xAzKVTemplate                                  0.0.1      xAz.KeyVault
    Function        New-xAzKVDeployment                                0.0.1      xAz.KeyVault
#>

# Edit the functions
$Name = Get-xAzKVName -Environment p
New-xAzKVDeployment -ResourceName $Name
```

## Documentation

- [Documentation](xAz.New/docs/en-US)
- [Examples](Examples)
- [Installation Notes](xAz.New/docs/en-US/InstallNotes.md)
- [Release Notes](xAz.New/docs/en-US/ReleaseNotes.md)
- TBD: [Wiki](https://github.com/mark-mit-k/Az.New/wiki)

## Dependencies

xAz.New Module

- [PSDepend](https://github.com/RamblingCookieMonster/PSDepend)
- [Plaster](https://github.com/PowerShell/Plaster)
- [Pester](https://github.com/Pester/Pester)
- [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)

### Build

for clean Build additionally [PSake](https://github.com/psake/psake)

## Code of Conduct

This is a personal repository by [markwarneke](https://github.com/markwarneke). Microsoft is **NOT** maintaining this repository, we stick to the [code of conduct](https://microsoft.github.io/codeofconduct/)

## Contact

- twitter: [@markwarneke](https://twitter.com/markwarneke)
- github: [markwarneke](https://github.com/markwarneke)
