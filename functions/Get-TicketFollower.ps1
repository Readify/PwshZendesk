
function Get-TicketFollower {
    <#
    .SYNOPSIS
        Gets followers for a ticket
    .DESCRIPTION
        Gets followers for a ticket
    .EXAMPLE
        PS C:\> Get-ZendeskTicketFollower -TicketId 1

        Gets followers for the ticket with id 1
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Unique Id of the ticket to get followers for
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

    $path = "/api/v2/tickets/$TicketId/followers"

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result

}
