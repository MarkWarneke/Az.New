function Test-UriStatus {
    [CmdletBinding()]
    param (
        # Link to site
        [Parameter(Mandatory)]
        [string]
        $uri
    )

    begin {
    }

    process {
        try {
            $HTTP_Request = [System.Net.WebRequest]::Create($Uri)
            $HTTP_Response = $HTTP_Request.GetResponse()
            $HTTP_Status = [int]$HTTP_Response.StatusCode

            switch ($HTTP_Status) {
                "200" { $true ; break}
                "400" { $false ; break}
                default { $true ; break}
            }
        }
        catch {
            $Execption = $_
            Write-Verbose "System.Net.WebRequest catched $($Execption.Exception)"
        }
        finally {
            try {
                if ($HTTP_Response) {
                    $HTTP_Response.Close()
                }
            }
            catch {
                Write-Verbose "Catched close"
            }
        }
    }

    end {
    }
}