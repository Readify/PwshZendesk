
function Update-Ticket {

    [OutputType([PSCustomObject])]
    [CMDletBinding(DefaultParameterSetName = 'Property', SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (

        # Tickets to update
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Object')]
        [PSCustomObject[]]
        $Ticket,

        # Ids of tickets to update
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Property')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64[]]
        $Id,

        # The subject of the ticket
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [String]
        $Subject,

        # An object that adds a comment to the ticket.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [PSCustomObject]
        $Comment,

        # The numeric ID of the user asking for support through the ticket
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $RequesterId,

        # The numeric ID of the agent to assign the ticket to
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $AssigneeId,

        # The email address of the agent to assign the ticket to
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidatePattern('@')]
        [String]
        $AssigneeEmail,

        # The numeric ID of the group to assign the ticket to
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $GroupId,

        # The numeric ID of the organization to assign the ticket to.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $OrganizationId,

        # An array of the numeric IDs of agents or end-users to CC.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $CollaboratorId,

        # An array of numeric IDs, emails, or objects containing name and email properties.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [Object[]]
        $Collaborator,

        # An array of numeric IDs, emails, or objects containing name and email properties.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [Object[]]
        $AdditionalCollaborators,

        # An array of objects that represent agent followers to add or delete from the ticket.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [Object[]]
        $Followers,

        # An array of objects that represent agent or end users email CCs to add or delete from the ticket.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [Object[]]
        $EmailCc,

        # Allowed values are problem, incident, question, or task
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidateSet('problem', 'incident', 'question', 'task')]
        [String]
        $Type,

        # Allowed values are urgent, high, normal, or low
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidateSet('urgent', 'high', 'normal', 'low')]
        [String]
        $Priority,

        # Allowed values are open, pending, hold, solved or closed
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidateSet('open', 'pending', 'hold', 'solved', 'closed')]
        $Status,

        # An array of tags to add to the ticket.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Tags,

        # An ID to link tickets to local records
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [String]
        $ExternalId,

        # For tickets of type "incident", the numeric ID of the problem the incident is linked to, if any
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $ProblemId,

        # For tickets of type "task", the due date of the task. Accepts the ISO 8601 date format (yyyy-mm-dd)
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [DateTime]
        $DueAt,

        # An array of the custom field objects consisting of ids and values.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [PSCustomObject[]]
        $CustomFields,

        # Datetime of last update received from API. See safe_update param
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [String]
        $UpdatedStamp,

        # Optional boolean. Prevents updates with outdated ticket data (updated_stamp param required when true)
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [Switch]
        $SafeUpdate,

        # An array of the numeric IDs of sharing agreements.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64[]]
        $SharingAgreementId,

        # An array of macro IDs to be recorded in the ticket audit
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64[]]
        $MacroId,

        # An array of the IDs of attribute values to be associated with the ticket
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Property')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64[]]
        $AttributeValueId,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    if ($PSCmdlet.ParameterSetName -eq 'Property') {

        if ($Id.Count -gt 1) {
            $ids = $Id -join ','
            $path = "/api/v2/tickets/update_many.json?ids=$ids"
        } else {
            $path = "/api/v2/tickets/$id.json"
        }

        $body = @{
            ticket = @{}
        }

        $map = @{
            subject                  = 'Subject'
            comment                  = 'Comment'
            requester_id             = 'RequesterId'
            assignee_id              = 'AssigneeId'
            assignee_email           = 'AssigneeEmail'
            group_id                 = 'GroupId'
            organization_id          = 'OrganizationId'
            collaborator_ids         = 'CollaboratorId'
            collaborators            = 'Collaborator'
            additional_collaborators = 'AdditionalCollaborators'
            followers                = 'Followers'
            email_ccs                = 'EmailCc'
            type                     = 'Type'
            priority                 = 'Priority'
            status                   = 'Status'
            tags                     = 'Tags'
            external_id              = 'ExternalId'
            problem_id               = 'ProblemId'
            due_at                   = 'DueAt'
            custom_fields            = 'CustomFields'
            updated_stamp            = 'UpdatedStamp'
            safe_update              = 'SafeUpdate'
            sharing_agreement_ids    = 'SharingAgreementId'
            macro_ids                = 'MacroId'
            attribute_value_ids      = 'AttributeValueId'
        }

        foreach ($item in $map.GetEnumerator()) {
            $property = $item.key
            $parameter = $item.value
            if ($PSBoundParameters.ContainsKey($parameter)) {
                $body.ticket[$property] = $PSBoundParameters.$parameter
            }
        }

    } else {

        if ($Ticket.count -gt 1) {
            $path = '/api/v2/tickets/update_many.json'
            $body = @{
                tickets = $Ticket
            }
        } else {
            $id = $Ticket.id
            $path = "/api/v2/tickets/$id.json"
            $body = @{
                ticket = $Ticket[0]
            }
        }

    }

    if ($PSCmdlet.ShouldProcess('Update Ticket')) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
