function Get-ArmTemplate {
    <#
    .SYNOPSIS
    Returns the link to the modules ARM template

    .DESCRIPTION
    Returns the link to the modules ARM template
    Can be configured in Modulemanifest (<%= $PLASTER_PARAM_ModuleName %>.psd1)  Attribute FileList = @('./static/azuredeploy.json')

    .EXAMPLE
    Get-<%= $PLASTER_PARAM_ModuleName %>ArmTemplate

    C:~>\<%= $PLASTER_PARAM_ModuleName %>\static\azuredeploy.json

    #>
    [CmdletBinding()]
    param (

    )

    begin {
    }

    process {
        $moduleFileList = $Local:MyInvocation.MyCommand.Module.FileList
        $TemplateUri = $moduleFileList[0]
        $TemplateUri
    }

    end {
    }
}