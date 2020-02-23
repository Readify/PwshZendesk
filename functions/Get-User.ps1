
function Get-User {
    <#
    .SYNOPSIS
        Retrieves one or more users.
    .DESCRIPTION
        Retrieves one or more users by Id, External Id, Group Id, Organziation Id, or role
    .EXAMPLE
        PS C:\> Get-ZendeskUser -Id 1

        Gets the user with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskUser -Id 1, 2, 3

        Gets the users with ids 1, 2, and 3
    .EXAMPLE
        PS C:\> Get-ZendeskUser -ExternalId 1

        Gets the user with external id 1
    .EXAMPLE
        PS C:\> Get-ZendeskUser -ExternalId 1, 2, 3

        Gets the users with external ids 1, 2, and 3
    .EXAMPLE
        PS C:\> Get-ZendeskUser -GroupId 1

        Gets the users in group with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskUser -OrganizationId 1

        Gets the users in organization with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskUser -Role 'admin'

        Gets users with the admin role
    .EXAMPLE
        PS C:\> Get-ZendeskUser -RoleId 1

        Gets users with the custom role with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskUser -Id 1 -SideLoad 'groups'

        Gets the user with id 1 and the groups they belong to.
    .EXAMPLE
        PS C:\> Get-ZendeskUser -Context $context -Id 1

        Gets the user with id 1 using a connection context from `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param (
        # Unique Id of the user to retrieve
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Id')]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64[]]
        $Id,

        # External Id of the user to retrieve
        [Parameter(Mandatory = $true,
            ParameterSetName = 'ExternalId')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ExternalId,

        # Unique Id of the group to retrieve users for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'GroupId')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $GroupId,

        # Unique Id of the organization to retrieve users for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'OrgId')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $OrganizationId,

        # Role to retrieve users for
        [Parameter(Mandatory = $false,
            ParameterSetName = 'GroupId')]
        [Parameter(Mandatory = $false,
            ParameterSetName = 'OrgId')]
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Default')]
        [ValidateSet('end-user', 'agent', 'admin')]
        [String[]]
        $Role,

        # Unique Id of the custom role to retrieve users for
        [Parameter(Mandatory = $false,
            ParameterSetName = 'GroupId')]
        [Parameter(Mandatory = $false,
            ParameterSetName = 'OrgId')]
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Default')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $RoleId,

        # Entities to sideload in the request
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(
            'abilities',
            'groups',
            'identities',
            'open_ticket_count',
            'organizations',
            'roles'
        )]
        [String[]]
        $SideLoad,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    $key = 'users'

    switch ($PSCmdlet.ParameterSetName) {
        'Id' {
            if ($Id.count -gt 1) {
                $ids = $Id -join ','
                $path = "/api/v2/users/show_many.json?ids=$ids"
            } else {
                $path = "/api/v2/users/$Id.json"
                $key = 'user'
            }
        }

        'ExternalId' {
            $ids = $ExternalId -join ','
            $path = "/api/v2/users/show_many.json?external_ids=$ids"
        }

        'GroupId' {
            $path = "/api/v2/groups/$GroupId/users.json"
        }

        'OrgId' {
            $path = "/api/v2/organizations/$OrganizationId/users.json"
        }

        default {
            $path = '/api/v2/users.json'
        }
    }

    Write-Debug -Message "Path: $path"

    if ($PSBoundParameters.ContainsKey('Role')) {
        if ($Role.count -gt 1) {
            $roles = $Role -join '&role[]='
            $path += "?role[]=$roles"
        } else {
            $path += "?role=$Role"
        }

        Write-Debug -Message "Path: $path"
    }

    if ($PSBoundParameters.ContainsKey('RoleId')) {
        $path += "?permission_set=$RoleId"
        Write-Debug -Message "Path: $path"
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
