$ModuleBase = Split-Path -Parent $MyInvocation.MyCommand.Path

# For tests in .\Module subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Module') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}
# For tests in .\Tests subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Test') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}

# Leave must match the module name e.g. xAz.New/xAz.New.psm1
$moduleName = Split-Path $ModuleBase -Leaf

Describe "General project validation: $moduleName"  -Tag Build {

    $scripts = Get-ChildItem $moduleRoot -Include *.ps1, *.psm1, *.psd1 -Recurse

    # TestCases are splatted to the script so we need hashtables
    $testCase = $scripts | Foreach-Object {@{file = $_}}
    It "Script <file> should be valid powershell" -TestCases $testCase {
        param($file)

        $file.fullname | Should Exist

        $contents = Get-Content -Path $file.fullname -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }

    It "Module '$moduleName' can import cleanly" {
        {Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force } | Should Not Throw
    }
}