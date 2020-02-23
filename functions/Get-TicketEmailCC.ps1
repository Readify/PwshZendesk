
function Get-TicketEmailCC {
    <#
    .SYNOPSIS
        Gets email ccs for a ticket
    .DESCRIPTION
        Gets email ccs for a ticket
    .EXAMPLE
        PS C:\> Get-ZendeskTicketEmailCC -TicketId 1

        Gets email ccs for the ticket with id 1.
    .EXAMPLE
        PS C:\> Get-ZendeskTicketEmailCC -Context $context -TicketId 1

        Gets email ccs for the ticket with id 1 with connection context from `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Unique Id of the ticket to get email ccs for
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

    $path = "/api/v2/tickets/$TicketId/email_ccs"

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result

}
