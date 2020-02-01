
function Get-SuspendedTicket {

    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of suspended ticket to retrieve
        [Parameter(Mandatory = $false)]
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
        $path = "/api/v2/suspended_tickets/destroy_many.json?ids=$ids"
    } else {
        $path = "/api/v2/suspended_tickets/$Id.json"
    }

    if ($PSCmdlet.ShouldProcess("$Id", 'Delete Suspended Ticket')) {
        $result = Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
