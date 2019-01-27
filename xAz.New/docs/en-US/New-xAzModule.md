---
external help file: xAz.New-help.xml
Module Name: xAz.New
online version:
schema: 2.0.0
---

# New-xAzModule

## SYNOPSIS
Create a PowerShell module in specified path.

## SYNTAX

```
New-xAzModule [-ModuleName] <String> [-ModuleDescription] <String> [-Path] <String>
 [[-DefaultCommandPrefix] <String>] [[-EMail] <String>] [[-CompanyName] <String>] [[-AuthorName] <String>]
 [[-TemplateUri] <String>] [[-Prefix] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Create a PowerShell module in specified path.
It can be used to deploy Azure Resource Manager Templates, if TemplateUri is provided
The scaffolding is based on \`Plaster\`, it generates tests and best practices checks for Azure Resource Manager Templates.

## EXAMPLES

### EXAMPLE 1
```
New-xAzModule -ModuleName "KeyVault" -ModuleDescription "Azure Tool Module to deploy Azure KeyVault" -Path "C:/temp" -DefaultCommandPrefix "xAzKV" -Email "warneke.mark@gmail.com" -CompanyName "microsoft"
```
```
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
```

### EXAMPLE 2
```
New-xAzModule -ModuleName 'Cosmos' -ModuleDescription 'Module to deploy Cosmos' -Path $Path -DefaultCommandPrefix = "xAzCosmos" -EMail = "mark.warneke@gmail.com" -CompanyName = "Microsoft" -AuthorName = "Mark" -TemplateUri "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-cosmosdb-create-arm-template/azuredeploy.json
```

Generates files into $Path
Downloads ARM tmeplate from URI

## PARAMETERS

### -ModuleName
Name of the new PowerShell module

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ModuleDescription
Description of the new PowerShell module

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Location where to generate PowerShell module files and folders

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultCommandPrefix
DefaultCommandPrefix in PowerShell Manifest file.
Is used to avoid Namespace.
The command will be prefixed with the DefaultCommandPrefix.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: XAz
Accept pipeline input: False
Accept wildcard characters: False
```

### -EMail
Contact E-Mail Address for Module Manifest

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompanyName
Company Name for Module Manifest

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthorName
Author Name for Manifest, will use local username if empty

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: $env:USERNAME
Accept pipeline input: False
Accept wildcard characters: False
```

### -TemplateUri
Uri to an ARM template to be used instead of blank

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Prefix
Prefix of the module, not the DefaultCommandPrefix.
Prefix will be prefixed of the module name to avoid Namespace conflicts.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: XAz.
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Dry run

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompt user confirmation

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
