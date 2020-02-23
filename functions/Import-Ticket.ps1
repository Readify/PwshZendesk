
function Import-Ticket {
    <#
    .SYNOPSIS
        Imports a ticket or tickets.
    .DESCRIPTION
        Imports a ticket or tickets. Allows setting timetstamps that are normally automatically set.
    .EXAMPLE
        PS C:\> Import-ZendeskTicket -Ticket $ticket

        Imports the ticket `$ticket` into the connected Zendesk instance.
    .EXAMPLE
        PS C:\> Import-ZendeskTicket -Ticket $tickets

        Imports the tickets `$tickets` into the connected Zendesk instance.
    .EXAMPLE
        PS C:\> Import-ZendeskTicket -Context $context -Ticket $ticket

        Imports the ticket `$ticket` into the Zendesk instance within $context from `Get-ZendeskConnection`.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Full ticket object to import
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]]
        $Ticket,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAdmin -Context $Context

    if ($Ticket.count -gt 1) {
        $path = '/api/v2/imports/tickets/create_many.json'
        $body = @{
            tickets = $Ticket
        }
    } else {
        $path = '/api/v2/imports/tickets.json'
        $body = @{
            ticket = $Ticket[0]
        }
    }

    $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
    $result

}
