
function Get-Tag {

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param (

        # Unique Id of the ticket to get tags for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Ticket')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $TicketId,

        # Unique Id of the organization to get tags for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Org')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $OrganizationId,

        # Unique Id of the user to get tags for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'User')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    switch ($PSCMDlet.ParameterSetName) {
        'Ticket' {
            $path = "/api/v2/tickets/$TicketId/tags.json"
        }

        'Org' {
            $path = "/api/v2/organizations/$OrganizationId/tags.json"
        }

        'User' {
            $path = "/api/v2/users/$UserId/tags.json"
        }

        default {
            $path = '/api/v2/tags.json'
        }
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand 'tags'

}
