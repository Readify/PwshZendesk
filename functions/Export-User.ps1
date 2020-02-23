
function Export-User {
    <#
    .SYNOPSIS
        Retrieves users updated since the supplied timestamp
    .DESCRIPTION
        Retrieves users updated since the supplied timestamp. Supply a timestamp of `0` to start fresh.
    .EXAMPLE
        PS C:\> Export-ZendeskUser -Timestamp 0

        Starts a fresh user incremental export.
    .EXAMPLE
        PS C:\> Export-ZendeskUser -Timestamp 132268985925191750

        Continues a user incremental export with a timestamp returned from a previous export.
    #>
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

    Assert-IsAdmin -Context $Context

    $path = "/api/v2/incremental/users.json?start_time=$Timestamp"

    $result = Invoke-Method -Context $Context -Path $path -Pagination $false -Verbose:$VerbosePreference
    $result

}
