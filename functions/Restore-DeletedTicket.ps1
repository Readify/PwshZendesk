
function Restore-DeletedTicket {

    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true)]
    Param (

        # Unique Id of soft deleted ticket to restore
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
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
        $path = "/api/v2/deleted_tickets/restore_many?ids=$ids"
    } else {
        $path = "/api/v2/deleted_tickets/$Id/restore.json"
    }

    if ($PSCmdlet.ShouldProcess("$Id", 'Restore deleted ticket.')) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Verbose:$VerbosePreference
        $result
    }
}
