
function Restore-SuspendedTicket {
    <#
    .SYNOPSIS
        Recovers one or more suspended tickets
    .DESCRIPTION
        Recovers one or more suspended tickets
    .EXAMPLE
        PS C:\> Restore-ZendeskSuspendedTicket -Id 1

        Recovers the suspended ticket with id 1
    .EXAMPLE
        PS C:\> Restore-ZendeskSuspendedTicket -Id 1, 2, 3

        Recovers the suspended tickets with ids 1, 2, and 3
    .NOTES
        When recovering a single ticket, the requester is set to the authenticated agent who called the API, not the original requester. This prevents the ticket from being re-suspended after recovery.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of suspended ticket to restore
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [ValidateNotNullOrEmpty()]
        [Int64[]]
        $Id,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    if ($Id.Count -gt 1) {
        $ids = $Id -join ','
        $path = "/api/v2/suspended_tickets/recover_many.json?ids=$ids"
    } else {
        $path = "/api/v2/suspended_tickets/$Id/recover.json"
    }

    if ($PSCmdlet.ShouldProcess("$Id", 'Restore suspended ticket.')) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
