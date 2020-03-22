
function Get-GroupMembership {
    <#
    .SYNOPSIS
        Gets Group Memberships
    .DESCRIPTION
        Gets Group Memberships
    .EXAMPLE
        PS C:\> Get-ZendeskGroupMembership

        Gets all group memberships.
    .EXAMPLE
        PS C:\> Get-ZendeskGroupMembership -Id 1

        Gets group membership with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskGroupMembership -Id 1 -UserId 2

        Gets group membership with id 1 for user with id 2
    .EXAMPLE
        PS C:\> Get-ZendeskGroupMembership -UserId 2

        Gets group memberships for user with id 2
    .EXAMPLE
        PS C:\> Get-ZendeskGroupMembership -GroupId 3

        Gets group memberships for group with id 3
    .EXAMPLE
        PS C:\> Get-ZendeskGroupMembership -Assignable

        Gets assignable group memberships
    .EXAMPLE
        PS C:\> Get-ZendeskGroupMembership -GroupId 3 -Assignable

        Gets assignable group memberships for group with id 3
    .EXAMPLE
        PS C:\> Get-ZendeskGroupMembership -Id 1 -SideLoad 'users', 'groups'

        Gets group membership with id 1 as well as the user and group for that membership
    #>
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
