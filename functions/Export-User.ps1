
function Export-User {

    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (

        # Timestamp returned by the last Export or `0` for a new incremental export
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, [Int64]::MaxValue)]
        [Int64]
        $Timestamp,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/api/v2/incremental/users.json?start_time=$Timestamp"

    $result = Invoke-Method -Context $Context -Path $path -Pagination $false -Verbose:$VerbosePreference
    $result

}
