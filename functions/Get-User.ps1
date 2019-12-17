
function Get-User {

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
    $result | Select-Object -Expand $key

}
