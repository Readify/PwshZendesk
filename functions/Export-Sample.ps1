
function Export-Sample {
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (

        # Name of the entity to get a sample export for
        [Parameter(Mandatory = $true)]
        [ValidateSet('tickets', 'users', 'organizations')]
        [String]
        $EntityName,

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

    $path = "/api/v2/incremental/$EntityName/sample.json?start_time=$Timestamp"

    $result = Invoke-Method -Context $Context -Path $path -Pagination $false -Verbose:$VerbosePreference
    $result

}
