
function Export-TicketEvent {
    <#
    .SYNOPSIS
        Retrieves ticket events updated since the supplied timestamp
    .DESCRIPTION
        Retrieves ticket events updated since the supplied timestamp. Supply a timestamp of `0` to start fresh.
    .EXAMPLE
        PS C:\> Export-ZendeskTicketEvent -Timestamp 0

        Starts a fresh ticket event incremental export.
    .EXAMPLE
        PS C:\> Export-ZendeskTicketEvent -Timestamp 132268985925191750

        Continues an ticket event incremental export with a timestamp returned from a previous export.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Timestamp returned by the last Export or `0` for a new incremental export
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, [Int64]::MaxValue)]
        [Int64]
        $Timestamp,

        # Entities to sideload in the request
        [Parameter(Mandatory = $false)]
        [ValidateSet('comment_events')]
        [String[]]
        $SideLoad,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAdmin -Context $Context

    $params = @{
        Context    = $Context
        Path       = "/api/v2/incremental/ticket_events.json?start_time=$Timestamp"
        Pagination = $false
        Verbose    = $VerbosePreference
    }

    if ($PSBoundParameters.ContainsKey('SideLoad')) {
        $params.SideLoad = $SideLoad
    }

    $result = Invoke-Method @params
    $result

}
