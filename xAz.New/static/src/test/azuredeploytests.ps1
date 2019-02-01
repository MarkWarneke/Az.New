param (
    $Path
)

$ModuleBase = Split-Path -Parent $MyInvocation.MyCommand.Path

if ((Split-Path $ModuleBase -Leaf) -eq 'Unit') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}


# For tests in .\Tests subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Test') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}

# Handles modules in version directories
$leaf = Split-Path $ModuleBase -Leaf
$parent = Split-Path $ModuleBase -Parent
$parsedVersion = $null
if ([System.Version]::TryParse($leaf, [ref]$parsedVersion)) {
    $ModuleName = Split-Path $parent -Leaf
}
# for VSTS build agent
elseif ($leaf -eq 's') {
    $ModuleName = $Env:Build_Repository_Name.Split('/')[1]
}
else {
    $ModuleName = $leaf
}
# Removes all versions of the module from the session before importing
Get-Module $ModuleName | Remove-Module
# For tests in .\Tests subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Test') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}
## this variable is for the VSTS tasks and is to be used for refernecing any mock artifacts
$Env:ModuleBase = $ModuleBase
Import-Module $ModuleBase\$ModuleName.psd1 -PassThru -ErrorAction Stop | Out-Null


if ($path) {
    $armTemplate = $path
}
else {
    $armTemplate = Get-<%=$PLASTER_PARAM_Prefix%>Template
}

Describe "test arm template $armTemplate" -Tag Unit {


    $null = Test-Path $armTemplate -ErrorAction Stop

    $TemplateFolder = Get-ChildItem (Split-Path $armTemplate -Parent)

    try {
        $text = Get-Content $armTemplate -Raw -ErrorAction Stop
    }
    catch {
        Write-Error "$($_.Exception) found"
        Write-Error "$($_.ScriptStackTrace)"
        break
    }

    try {
        $json = ConvertFrom-Json $text -ErrorAction Stop
    }
    catch {
        $JsonException = $_
    }


    it "should throw no expection" {
        $JsonException | Should -BeNullOrEmpty
    }

    it "should have content" {
        $json | Should -Not -BeNullOrEmpty
    }

    it "should have metadata.json" {
        $TemplateFolder | Where-Object Name -match 'metadata.json' | Should -be "metadata.json"
    }

    it "should have parameters.json" {
        $TemplateFolder | Where-Object Name -match 'parameters.json' | Should -BeLike "*parameters.json"
    }

    $TestCases = @(
        @{
            Expected = "parameters"
        },
        @{
            Expected = "variables"
        },
        @{
            Expected = "resources"
        },
        @{
            Expected = "outputs"
        }
    )

    it "should have <Expected>" -TestCases $TestCases {
        param(
            $Expected
        )

        $json.PSObject.Members.Name | Should -Contain $Expected
        # $json.$Expected | Should -Not -BeNullOrEmpty
    }

    context "parameters tests" {
        $parameters = $json.parameters | Get-Member -MemberType NoteProperty
        if ($parameters) {
            foreach ($parameter in $parameters) {
                $ParameterName = $($parameter.Name)
                it "$ParameterName should have metadata" {
                    $json.parameters.$ParameterName.metadata | Should -Not -BeNullOrEmpty
                }
            }
        }
        else {
            Write-Warning "Could NOT find parameters"
        }

    }

    context "resources tests" {
        foreach ($resource in $json.resources) {
            $type = $resource.type
            it "$type should have comment" {
                $resource.comments  | Should -Not -BeNullOrEmpty
            }
        }
    }

    context "resources structure test" {
        foreach ($resource in $json.resources) {
            it "should follow comment > type > apiVersion > name > properties" {
                "$resource" | Should -BeLike "*comments*type*apiVersion*name*properties*"
            }
        }
    }
}