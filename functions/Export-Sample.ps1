
function Export-Sample {
    <#
    .SYNOPSIS
        Gets a sample incremental export of the specified type.
    .DESCRIPTION
        Gets a sample incremental export of the specified type.
    .EXAMPLE
        PS C:\> Export-ZendeskSample -EntityName 'tickets -Timestamp 0

        Gets a sample ticket incremental export.
    .EXAMPLE
        PS C:\> Export-ZendeskSample -EntityName 'users -Timestamp 0

        Gets a sample user incremental export.
    .EXAMPLE
        PS C:\> Export-ZendeskSample -EntityName 'organizations -Timestamp 0

        Gets a sample organization incremental export.
    .EXAMPLE
        PS C:\> Export-ZendeskSample -EntityName 'tickets -Timestamp 132268985925191750

        Gets a sample ticket incremental export with a timestamp returned from a previous export.
    #>
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

    Assert-IsAdmin -Context $Context

    $path = "/api/v2/incremental/$EntityName/sample.json?start_time=$Timestamp"

    $result = Invoke-Method -Context $Context -Path $path -Pagination $false -Verbose:$VerbosePreference
    $result

}
