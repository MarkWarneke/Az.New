# Examples

## createBasic.ps1

run `creatBaisc.ps1`

```PowerShell
help createBasic.ps1

# Generates new module into C:\temp\xAz.KeyVault
# Opens location provided in Path
# Will wait for confirmation to delete generated module, can be denied to leave module existing
createBasic.ps1 -Path "C:\temp"
```

## createCosmosDb.ps1

run `createCosmosDb.ps1`

```PowerShell
help createCosmosDb.ps1

# Generates new module into C:\temp\xAz.Cosmos
# Creates a custom ARM template into the module, the template is downloaded from the azure-quickstart-templates repo (https://github.com/Azure/azure-quickstart-templates)
# Opens location provided in Path
# Will wait for confirmation to delete generated module, can be denied to leave module existing
createCosmosDb.ps1 -Path "C:\temp"
```