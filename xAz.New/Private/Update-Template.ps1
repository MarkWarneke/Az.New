function Update-Template {
    [CmdletBinding()]
    param (
        [string] $TemplateUri,
        [string] $Path
    )

    begin {
    }

    process {

        $ExistingTemplate = Join-Path -Path $Path -ChildPath "Static/azuredeploy.json" -ErrorAction Stop

        if ($TemplateUri) {
            if (Test-Url $TemplateUri) {
                #e.g. https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-1vm-2nics-2subnets-1vnet/azuredeploy.json
                Write-Verbose "[$(Get-Date)] Download File from $TemplateUri"
                $Template = Invoke-WebRequest -Method Get -Uri $TemplateUri -ErrorAction Stop

                Write-Verbose "[$(Get-Date)] Replace generated $ExistingTemplate with $TemplateUri"
                Set-Content -Path $ExistingTemplate -Value $Template -Force -PassThru
            }
            else {
                Write-Verbose "[$(Get-Date)] Replace generated $ExistingTemplate with $TemplateUri"
                Move-Item $TemplateUri $ExistingTemplate -Force -PassThru
            }
        }
        else {
            Write-Verbose "[$(Get-Date)] Keep generated $ExistingTemplate"
        }
    }

    end {
    }
}