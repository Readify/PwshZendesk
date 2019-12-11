
function Get-Group {

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
    $result | Select-Object -Expand $key

}
