
function Get-TicketRelated {
    <#
    .SYNOPSIS
        Retrieves data related to a supplied ticket
    .DESCRIPTION
        Retrieves data related to a supplied ticket
    .EXAMPLE
        PS C:\> Get-ZendeskTicketRelated -TicketId 1

        Retrieve data related to ticket with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskTicketRelated -Context $context -TicketId 1

        Retrieve data related to ticket with id 1 using a connection context returned by `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Unique Id of the ticket to get related information for
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

    $path = "/api/v2/tickets/$TicketId/related.json"

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result

}
