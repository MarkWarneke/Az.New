$script:ModuleName = 'xAz.New'
# Removes all versions of the module from the session before importing
Get-Module $ModuleName | Remove-Module
$ModuleBase = Split-Path -Parent $MyInvocation.MyCommand.Path

# For tests in .\Test\Unit subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Unit') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}

# For tests in .\Test subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Test') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}
## this variable is for the VSTS tasks and is to be used for refernecing any mock artifacts
$Env:ModuleBase = $ModuleBase
Import-Module $ModuleBase\$ModuleName.psd1 -PassThru -ErrorAction Stop | Out-Null
Describe "New-Module function unit tests" -Tags Build , Unit {

    $ModuleName = 'KeyVault'
    $DefaultCommandPrefix = 'xAzKV'
    $input = @{
        ModuleName           = $ModuleName
        ModuleDescription    = 'Function to deploy KeyVault'
        Path                 = "$TestDrive"
        DefaultCommandPrefix = $DefaultCommandPrefix
        EMail                = "mark.warneke@gmail.com"
        CompanyName          = "Microsoft"
        AuthorName           = "Mark"
    }
    $Module = New-xAzModule @input -Verbose -ErrorVariable $E

    it "should not throw an error" {
        $E | Should -BeNullOrEmpty
    }

    context "Module scaffolding" {
        $item = Get-ChildItem $TestDrive -Recurse

        $TestCase = @(
            @{
                Position = 0
                Expected = $ModuleName
            },
            @{
                Position = 1
                Expected = ".vscode"
            },
            @{
                Position = 2
                Expected = "Classes"
            },
            @{
                Position = 3
                Expected = "docs"
            },
            @{
                Position = 4
                Expected = "Localization"
            },
            @{
                Position = 5
                Expected = "Private"
            },
            @{
                Position = 6
                Expected = "Public"
            },
            @{
                Position = 7
                Expected = "Static"
            },
            @{
                Position = 8
                Expected = "Test"
            },
            @{
                Position = 9
                Expected = "CommonResourceHelper"
            },
            @{
                Position = 10
                Expected = "KeyVaultSecrets.psd1"
            },
            @{
                Position = 11
                Expected = "{0}{1}" -f $ModuleName, ".psd1"
            },
            @{
                Position = 12
                Expected = "{0}{1}" -f $ModuleName, ".psm1"
            }
        )

        it "should create <Expected>" -TestCases $TestCase {
            param(
                $Position,
                $Expected
            )

            $item[$Position] | Should -Match $Expected
        }
    }

    context "Manifest manipulation tests" {
        $ManifestName = "{0}{1}{2}" -f "xAz.", $ModuleName, ".psd1"
        $Manifest = Get-Content (Join-Path -Path $Module.DestinationPath -ChildPath $ManifestName)

        $TestCaseManifest = @(
            @{
                Position = 119
                Expected = "DefaultCommandPrefix = '$DefaultCommandPrefix'"
            },
            @{
                Position = 89
                Expected = "FileList = @('./Static/azuredeploy.json')"
            }<#,
            @{
                Position = 53
                Expected = "RequiredModules = @('Az')"
            }#>
        )
        it "should update Manifest $ManifestName on Position <Position>" -TestCases $TestCaseManifest {
            param (
                $Position,
                $Expected
            )

            $Manifest[$Position] | Should -Be $Expected
        }
    }

}