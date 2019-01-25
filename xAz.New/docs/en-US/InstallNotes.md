# Installing Az.New

You can install Az.New
```PowerShell
Copy-Item Az.New "$HOME\Documents\WindowsPowerShell\Modules\Az.New"
Import-Module Az.New
```


# Installing Az.New

You can install latest Az.New

```PowerShell
git clone  https://github.com/mark-mit-k/Az.New.git --branch master --single-branch [<folder>]

Copy-Item Az.New "$HOME\Documents\WindowsPowerShell\Modules\Az.New"
Install-Module "$HOME\Documents\WindowsPowerShell\Modules\Az.New"
```

## Import

You can load Az.New

``` PowerShell
Import-Module .\Az.New\Az.New.psd1
Get-Command -Module Az.New
```

## Build and Test

Run individual tests from folder `.\Az.New\Test`

```PowerShell
Invoke-Pester .\Az.New\Test\
```
