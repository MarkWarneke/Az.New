param (
    $Path = (Join-Path $PSScriptRoot 'azuredeploy.json')
)
Describe "should be valid" {

    $null = Test-Path $Path -ErrorAction Stop

    try {
        $text = Get-Content $Path -Raw -ErrorAction Stop
    }
    catch {
        Write-Host "$($_.Exception) found"
        Write-Host "$($_.ScriptStackTrace)"
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

        $json.$Expected | Should -Not -BeNullOrEmpty
    }

    context "parameters tests" {
        $parameters = $json.parameters | Get-Member -MemberType NoteProperty
        foreach ($parameter in $parameters) {
            $ParameterName = $($parameter.Name)
            it "$ParameterName should have metadata" {
                $json.parameters.$ParameterName.metadata | Should -Not -BeNullOrEmpty
            }
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

}