
function Get-TicketCollaborator {
    <#
    .SYNOPSIS
        Gets collaborators for a ticket.
    .DESCRIPTION
        Gets collaborators for a ticket.
    .EXAMPLE
        PS C:\> Get-ZendeskTicketCollaborator -TicketId 1

        Gets collaborators for ticket with id 1.
    .EXAMPLE
        PS C:\> Get-ZendeskTicketCollaborator -Context $context -TicketId 1

        Gets collaborators for ticket with id 1 using a connection context from `Get-ZendeskConnection`.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Unique Id of the ticket to get Collaborators for
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

    $path = "/api/v2/tickets/$TicketId/collaborators.json"

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result

}
