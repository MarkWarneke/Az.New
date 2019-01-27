# InstallNotes

## Installing xAz.New

You can install latest xAz.New with cloning the git repository and copying it locally.

```PowerShell
git clone  https://github.com/mark-mit-k/Az.New.git --branch master --single-branch [<folder>]

Copy-Item "Az.New\xAz.New" "$HOME\Documents\WindowsPowerShell\Modules" -Recurse # Add force to update
```

## Import and Usage

You can load Az.New without installing, once installed

``` PowerShell
Import-Module xAz.New
Get-Command -Module xAz.New
```

## Build and Test

Run individual tests from folder `.\Az.New\Test`

```PowerShell
Invoke-Pester .\Az.New
```

## Uninstall

Depending on your installation you can run

```PowerShell
Remove-Item $HOME\Documents\WindowsPowerShell\Modules\xAz.New\ -Recurse -Force
```