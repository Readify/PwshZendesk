
function Get-Ticket {
    <#
    .SYNOPSIS
        Gets one or more tickets
    .DESCRIPTION
        Gets one or more tickets by Id, External Id, User Id, or OrganizationId with optional filters.
    .EXAMPLE
        PS C:\> Get-ZendeskTicket

        Gets all tickets
    .EXAMPLE
        PS C:\> Get-ZendeskTicket -Id 1

        Gets the ticket with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskTicket -Id 1, 2, 3

        Gets the tickets with ids 1, 2, and 3
    .EXAMPLE
        PS C:\> Get-ZendeskTicket -ExternalId 1

        Gets ticket with external id 1
    .EXAMPLE
        PS C:\> Get-ZendeskTicket -UserId 1 -Requested

        Gets tickets requested by the user with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskTicket -UserId 1 -Assigned

        Gets tickets assigned to the user with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskTicket -UserId 1 -CCd

        Gets tickets with the user with id 1 CC'd
    .EXAMPLE
        PS C:\> Get-ZendeskTicket -OrganizationId 1

        Gets tickets from the organization with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskTicket -Recent

        Gets tickets recently viewed by the logged in user.
    .EXAMPLE
        PS C:\> Get-ZendeskTicket -Id 1 -SideLoad 'groups'

        Gets the ticket with id 1 as well as the group it is assigned to.
    .EXAMPLE
        PS C:\> Get-ZendeskTicket -Context $context

        Gets all tickets using a connection context from `Get-ZendeskConnection`
    #>
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

    if (-not $PSBoundParameters.ContainsKey('SideLoad')) {
        $result | Select-Object -Expand $key
    }
}

