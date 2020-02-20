
function Export-TicketEvent {

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
