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
        [string] $AuthorName = $env:USERNAME,

        [Parameter()]
        [string] $TemplateUri,

        [Parameter()]
        [string] $Prefix = "xAz."
    )

    $TemplatePath = Get-xAzManifest
    $NewModuleName = "{0}{1}" -f $Prefix, $ModuleName
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

        if ($pscmdlet.ShouldProcess($DestinationPath, 'Invoke-Plaster')) {
            Write-Verbose -Message "[$(Get-Date)] Create folder"
            New-Item -ItemType Directory -Path $DestinationPath
            Write-Verbose -Message "[$(Get-Date)] Generate Module"
            $plaster = Invoke-Plaster -DestinationPath $DestinationPath -TemplatePath $TemplateDirectory @plaster -PassThru

            $GeneratedModuleManifestFile = Get-ChildItem -Path $DestinationPath -Name "$NewModuleName.psd1" -ErrorAction Stop
            $null = Update-Manifest -Path $GeneratedModuleManifestFile.PSPath -DefaultCommandPrefix $DefaultCommandPrefix


            $null = Update-Template -Path $DestinationPath -TemplateUri $TemplateUri

            $plaster
        }
    }
    else {
        Write-Error ("New Module Path already exsists! {0} not created" -f $NewModuleName)
    }
}
