function Get-Manifest {
    <#
    .SYNOPSIS
    Returns the link to the modules template

    .DESCRIPTION
    Returns the link to the modules template
    Can be configured in Modulemanifest (Az.New.psd1)
    Attribute FileList = @('./static/template.json')

    .EXAMPLE
    Get-NewTemplate

    .\Az.New\static\template.json

    #>
    [CmdletBinding()]
    param (

    )

    begin {
    }

    process {
        $moduleFileList = $Local:MyInvocation.MyCommand.Module.FileList
        $TemplateUri = $moduleFileList[0]
        Write-Verbose -Message ($script:localizedData.RetrievingFolderInformation -f $moduleFileList)
        $TemplateUri
    }

    end {
    }
}
