
function Remove-Ticket {

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
