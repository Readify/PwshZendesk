
function Get-Incident {
    <#
    .SYNOPSIS
        Gets incidents associated with the given problem ticket.
    .DESCRIPTION
        Gets incidents associated with the given problem ticket.
    .EXAMPLE
        PS C:\> Get-ZendeskIncident -TicketId 1

        Gets incidents associated with the problem ticket with id 1.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Unique Id of the problem ticket to get linked incidents for
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $TicketId,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/api/v2/tickets/$TicketId/incidents.json"

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand 'tickets'

}
