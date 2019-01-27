function Get-Manifest {
    <#
    .SYNOPSIS
    Returns the link to the modules template

    .DESCRIPTION
    Returns the link to the modules template
    Can be configured in Modulemanifest (xAz.New.psd1)
    Attribute FileList = @('./static/PlasterManifest.xml')

    .EXAMPLE
    Get-xAzManifest

    .\Az.New\static\PlasterManifest.xml

    #>
    [CmdletBinding()]
    param ()

    begin {
        $moduleFileList = $Local:MyInvocation.MyCommand.Module.FileList
        $TemplateUri = $moduleFileList[0]
    }
    process {
        Write-Verbose -Message ($script:localizedData.RetrievingFolderInformation -f $moduleFileList)
        $TemplateUri
    }
}
