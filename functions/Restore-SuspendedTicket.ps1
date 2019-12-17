
function Restore-SuspendedTicket {

    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true)]
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
