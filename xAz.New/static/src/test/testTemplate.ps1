###############################################################################
# Dot source the import of module
###############################################################################
. $PSScriptRoot\shared.ps1

Describe "<%= $PLASTER_PARAM_FunctionName %> function unit tests" -Tags Unit {

    It "Rule <%= $PLASTER_PARAM_FunctionName %>" {

        # <%= $PLASTER_PARAM_FunctionName %> | Should Be $true
    }

}