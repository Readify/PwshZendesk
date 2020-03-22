
function Get-Comment {
    <#
    .SYNOPSIS
        Gets comments for a given ticket.
    .DESCRIPTION
        Gets comments for a given ticket.
    .EXAMPLE
        PS C:\> Get-ZendeskComment -TicketId 1

        Gets comments on ticket with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskComment -Context $context -TicketId 1

        Gets comments on ticket with id 1 with a connection context from `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    Param (
        # Unique Id of the ticket to get comments for
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

    Assert-IsAgent -Context $Context

    $path = "/api/v2/tickets/$TicketId/comments.json"

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand 'comments'
}
