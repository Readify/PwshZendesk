
function Get-DeletedTicket {

    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = '/api/v2/deleted_tickets.json'

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand 'deleted_tickets'

}
