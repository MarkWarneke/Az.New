# Installing <%= $PLASTER_PARAM_ModuleName %>

You can install <%= $PLASTER_PARAM_ModuleName %>
```PowerShell
Copy-Item <%= $PLASTER_PARAM_ModuleName %> "$HOME\Documents\WindowsPowerShell\Modules\<%= $PLASTER_PARAM_ModuleName %>"
Import-Module <%= $PLASTER_PARAM_ModuleName %>
```


# Installing <%= $PLASTER_PARAM_ModuleName %>

You can install <%= $PLASTER_PARAM_ModuleName %>

```PowerShell
git clone  https:\\github.com/<MyRepo>/_git/<repo> --branch master --single-branch [<folder>]

Copy-Item <%= $PLASTER_PARAM_ModuleName %> "$HOME\Documents\WindowsPowerShell\Modules\<%= $PLASTER_PARAM_ModuleName %>"
Import-Module <%= $PLASTER_PARAM_ModuleName %>
```

## Import

You can load <%= $PLASTER_PARAM_ModuleName %>

``` PowerShell
Import-Module .\<%= $PLASTER_PARAM_ModuleName %>\<%= $PLASTER_PARAM_ModuleName %>.psd1
Get-Command -Module <%= $PLASTER_PARAM_ModuleName %>
```

## Build and Test

Run individual tests from folder `.\<%= $PLASTER_PARAM_ModuleName %>\Test`

```PowerShell
Invoke-Pester .\<%= $PLASTER_PARAM_ModuleName %>\Test\
```
