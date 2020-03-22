
function Get-Group {
    <#
    .SYNOPSIS
        Retrieves a group or groups
    .DESCRIPTION
        Retrieves all groups, assignable groups, groups by User, or a specific group.
    .EXAMPLE
        PS C:\> Get-ZendeskGroup

        Retrieves all groups
    .EXAMPLE
        PS C:\> Get-ZendeskGroup -Id 1

        Retrieves group with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskGroup -UserId 1

        Retrieves groups assigned to User with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskGroup -Assignable

        Retrieves assignable groups
    .EXAMPLE
        PS C:\> $result = Get-ZendeskGroup -Id 1 -SideLoad users
        PS C:\> $group = $result.group
        PS C:\> $members = $result.users

        Retrieves group with id 1 with users assigned to that group side loaded.
    .EXAMPLE
        PS C:\> Get-ZendeskGroup -Context $context

        Retrieves all groups supplying a connection context returned by `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param (
        # Unique Id of the group to retrieve
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Id')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Unique Id of the User whose groups to retrieve
        [Parameter(Mandatory = $true,
            ParameterSetName = 'UserId')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Only retrieve groups that can be assigned
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Assignable')]
        [Switch]
        $Assignable,

        #
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(
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

    $key = 'groups'

    switch ($PSCMDlet.ParameterSetName) {
        'Id' {
            $path = "/api/v2/groups/$Id.json"
            $key = 'group'
        }

        'UserId' {
            $path = "/api/v2/users/$UserId/groups.json"
        }

        'Assignable' {
            $path = '/api/v2/groups/assignable.json'
        }

        default {
            $path = '/api/v2/groups.json'
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
