
function Remove-Ticket {
    <#
    .SYNOPSIS
        Deletes specified ticket or tickets.
    .DESCRIPTION
        Deletes specified ticket or tickets.
    .EXAMPLE
        PS C:\> Remove-ZendeskTicket -Id 1

        Delete ticket with id 1.
    .EXAMPLE
        PS C:\> Remove-ZendeskTicket -Id 1, 2, 3

        Delete tickets with ids 1, 2, and 3.
    .EXAMPLE
        PS C:\> Remove-ZendeskTicket -Id 1 -Permanent

        Permanently deletes deleted ticket with id 1.
    .EXAMPLE
        PS C:\> Remove-ZendeskTicket -Id 1, 2, 3 -Permanent

        Permanently deletes deleted tickets with ids 1, 2, and 3.
    .EXAMPLE
        PS C:\> Remove-ZendeskTicket -Context $context -Id 1

        Delete ticket with id 1 with connection context from `Get-ZendeskConnection`.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of the ticket to delete
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64[]]
        $Id,

        # Permanently deleted a deleted ticket
        [Parameter(Mandatory = $false)]
        [Switch]
        $Permanent,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    if ($Id.Count -gt 1) {
        $ids = $Id -join ','

        if ($Permanent) {
            $path = "/api/v2/deleted_tickets/destroy_many?ids=$ids"
        } else {
            $path = "/api/v2/tickets/destroy_many.json?ids=$ids"
        }
    } else {
        if ($Permanent) {
            $path = "/api/v2/deleted_tickets/$Id.json"
        } else {
            $path = "/api/v2/tickets/$Id.json"
        }
    }

    if ($PSCmdlet.ShouldProcess("$Id", 'Delete Ticket')) {
        $result = Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
