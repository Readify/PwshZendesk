
function Get-GroupMembership {

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param (

        # Unique Id of the group membership to retrieve
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Id')]
        [Parameter(Mandatory = $false,
            ParameterSetName = 'UserId')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Unique Id of the user to get group memberships for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'UserId')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Unique Id of the group to get membersips for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'GroupId')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $GroupId,

        # Only retrieve assignable memberships
        [Parameter(Mandatory = $false,
            ParameterSetName = 'GroupId')]
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Default')]
        [Switch]
        $Assignable,

        # Entities to sideload in the request
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(
            'groups',
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

    Assert-IsAgent -Context $Context

    $key = 'group_memberships'

    switch ($PSCMDlet.ParameterSetName) {
        'Id' {
            $path = "/api/v2/group_memberships/$Id.json"
            $key = 'group_membership'
        }

        'UserId' {
            if ($PSBoundParameters.ContainsKey('Id')) {
                $path = "/api/v2/users/$UserId/group_memberships/$Id.json"
            } else {
                $path = "/api/v2/users/$UserId/group_memberships.json"
            }
        }

        'GroupId' {
            if ($Assignable) {
                $path = "/api/v2/groups/$GroupId/memberships/assignable.json"
            } else {
                $path = "/api/v2/groups/$GroupId/memberships.json"
            }
        }

        default {
            if ($Assignable) {
                $path = '/api/v2/group_memberships/assignable.json'
            } else {
                $path = '/api/v2/group_memberships.json'
            }
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
