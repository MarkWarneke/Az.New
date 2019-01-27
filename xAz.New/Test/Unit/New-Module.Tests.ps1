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


    $input = @{
        ModuleName           = 'KeyVault'
        ModuleDescription    = 'Function to deploy KeyVault'
        Path                 = "$TestDrive"
        DefaultCommandPrefix = "xAzKV"
        EMail                = "mark.warneke@gmail.com"
        CompanyName          = "Microsoft"
        AuthorName           = "Mark"
    }
    New-xAzModule @input -Verbose -ErrorVariable $E

    it "should not throw an error" {
        $E | Should -BeNullOrEmpty
    }

    $item = Get-ChildItem $TestDrive -Recurse

    $TestCase = @(
        @{
            Position = 0
            Expected = "{0}{1}" -f $input.DefaultCommandPrefix, $input.ModuleName
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
            Expected = "Private"
        },
        @{
            Position = 5
            Expected = "Public"
        },
        @{
            Position = 6
            Expected = "Static"
        },
        @{
            Position = 7
            Expected = "Test"
        },
        @{
            Position = 9
            Expected = "{0}{1}{2}" -f $input.DefaultCommandPrefix, $input.ModuleName, ".psd1"
        },
        @{
            Position = 10
            Expected = "{0}{1}{2}" -f $input.DefaultCommandPrefix, $input.ModuleName, ".psm1"
        }
    )

    it "should create <Expected>" -TestCases $TestCase {
        param(
            $Position,
            $Expected
        )

        $item[$Position] | Should Be $Expected
    }



}