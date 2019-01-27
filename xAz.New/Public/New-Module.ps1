function New-Module {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory)]
        [string] $ModuleName,

        [Parameter(Mandatory)]
        [string] $ModuleDescription,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter()]
        [string] $DefaultCommandPrefix = "xAz",

        [Parameter()]
        [string] $EMail,

        [Parameter()]
        [string] $CompanyName,

        [Parameter()]
        [string] $AuthorName = $env:USERNAME
    )

    $TemplatePath = Get-xAzManifest
    $NewModuleName = "{0}{1}" -f $DefaultCommandPrefix, $ModuleName
    $DestinationPath = (Join-Path $Path $NewModuleName)  # Must be named exactly like ModuleName for tests

    $plaster = @{
        AuthorName        = $AuthorName
        CompanyName       = $CompanyName
        ModuleName        = $NewModuleName
        ModuleDescription = $ModuleDescription
        Version           = "0.0.1"
        EMail             = $EMail
        Prefix            = $DefaultCommandPrefix
    }

    if (!(Test-Path -LiteralPath $DestinationPath)) {
        # Resolve any relative paths
        $DestinationPath = $psCmdlet.SessionState.Path.GetUnresolvedProviderPathFromPSPath($DestinationPath)
        $TemplateDirectory = Split-Path $TemplatePath -Parent

        if ($pscmdlet.ShouldProcess($DestinationPath, 'Operation')) {
            New-Item -ItemType Directory -Path $DestinationPath
            Invoke-Plaster -DestinationPath $DestinationPath -TemplatePath $TemplateDirectory @plaster -PassThru
        }
    }
    else {
        Write-Error ("New Module Path already exsists! {0} not created" -f $NewModuleName)
    }
}