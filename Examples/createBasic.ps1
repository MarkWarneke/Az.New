param(
    $Path = "C:\temp"
)

Import-Module (Join-Path -Path (Split-Path $PSScriptRoot -Parent) -ChildPath "xAz.New/xAz.New.psd1") -Force

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

$Module
Invoke-Item $Module.DestinationPath

Remove-Item -Path $Module.DestinationPath -Recurse -Force -Confirm