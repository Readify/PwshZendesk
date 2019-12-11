
function Get-Ticket {

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param (
        # Unique Id of the ticket to retrieve
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Id')]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64[]]
        $Id,

        # External Id of the ticket to retrieve
        [Parameter(Mandatory = $true,
            ParameterSetName = 'ExternalId')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ExternalId,

        # Unique Id of the user associated with this ticket.
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Requested')]
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Assigned')]
        [Parameter(Mandatory = $true,
            ParameterSetName = 'CCd')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Retrieve only tickets requested by user specified by `-UserId`
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Requested')]
        [Switch]
        $Requested,

        # Retrieve only tickets assigned to user specified by `-UserId`
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Assigned')]
        [Switch]
        $Assigned,

        # Retrieve only tickets with the user specified by `-UserId` CC'd
        [Parameter(Mandatory = $true,
            ParameterSetName = 'CCd')]
        [Switch]
        $CCd,

        # UniqueId of the Organization to retrieve tickets for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'OrgId')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $OrganizationId,

        # Only retrieve recently viewed by the logged in user
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Recent')]
        [Switch]
        $Recent,

        # Entities to sideload in the request
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(
            'comment_count',
            'dates',
            'groups',
            'incident_counts',
            'last_audits',
            'metric_events',
            'metric_sets',
            'organizations',
            'sharing_agreements',
            'slas',
            'ticket_forms',
            'users'
        )]
        [String[]]
        $SideLoad,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $key = 'tickets'

    switch ($PSCmdlet.ParameterSetName) {
        'Id' {
            if ($Id.count -gt 1) {
                $ids = $Id -join ','
                $path = "/api/v2/tickets/show_many.json?ids=$ids"
            } else {
                $path = "/api/v2/tickets/$Id.json"
                $key = 'ticket'
            }
        }

        'ExternalId' {
            $path = "/api/v2/tickets.json?external_id=$ExternalId"
        }

        'Requested' {
            $path = "/api/v2/users/$UserId/tickets/requested.json"
        }

        'Assigned' {
            $path = "/api/v2/users/$UserId/tickets/assigned.json"
        }

        'CCd' {
            $path = "/api/v2/users/$UserId/tickets/ccd.json"
        }

        'OrgId' {
            $path = "/api/v2/organizations/$OrganizationId/tickets.json"
        }

        'Recent' {
            $path = '/api/v2/tickets/recent.json'
        }

        default {
            $path = '/api/v2/tickets.json'
        }
    }

    $params = @{
        Context = $Context
        Path    = $path
        Verbose = $VerbosePreference
    }

    if ($PSBoundParameters.ContainsKey('SideLoad')) {
        $params.SideLoad = $SideLoad
    }

    $result = Invoke-Method @params
    $result | Select-Object -Expand $key

}

