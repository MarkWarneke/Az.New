function Get-PipelineFiles {
    <#
    .SYNOPSIS
    Returns the link to the pipeline template

    .DESCRIPTION
    Returns the link to the pipeline template
    Can be configured in Modulemanifest (xAz.New.psd1)

    .EXAMPLE
    Get-xAzPipelineFiles

    .\Az.New\static\pipeline

    #>
    [CmdletBinding()]
    param ()

    begin {
        $moduleFileList = $Local:MyInvocation.MyCommand.Module.FileList
        $path = $moduleFileList[1]
    }
    process {
        Write-Verbose -Message ($script:localizedData.RetrievingFolderInformation -f $path)
        Get-ChildItem $path
    }
}
