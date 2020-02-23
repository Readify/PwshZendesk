
function Get-OrganizationMembership {
    <#
    .SYNOPSIS
        Retrieves organization membershipss
    .DESCRIPTION
        Retrieves organization membershipss by Id, User, or Organization
    .EXAMPLE
        PS C:\> Get-ZendeskOrganizationMembership

        Retrieves all organization memberships.
    .EXAMPLE
        PS C:\> Get-ZendeskOrganizationMembership -Id 1

        Retrieves organization membership with id 1.
    .EXAMPLE
        PS C:\> Get-ZendeskOrganizationMembership -UserId 2

        Retrieves organization memberships for user with id 2
    .EXAMPLE
        PS C:\> Get-ZendeskOrganizationMembership -Id 1 -UserId 2

        Retrieves organization membership with id 1 explicitly associated with user with id 2
    .EXAMPLE
        PS C:\> Get-ZendeskOrganizationMembership -OrganizationId 1

        Retrieves organization memberships associated with organization with id 1
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param (
        # Unique Id of the organization membership to retrieve
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Id')]
        [Parameter(Mandatory = $false,
            ParameterSetName = 'UserId')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Unique Id of the user to get organization memberships for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'UserId')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Unique Id of the organization to get memberships for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'OrganizationId')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $OrganizationId,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    $key = 'organization_memberships'

    switch ($PSCMDlet.ParameterSetName) {
        'Id' {
            $path = "/api/v2/organization_memberships/$Id.json"
            $key = 'organization_membership'
        }

        'UserId' {
            if ($PSBoundParameters.ContainsKey('Id')) {
                $path = "/api/v2/users/$UserId/organization_memberships/$Id.json"
            } else {
                $path = "/api/v2/users/$UserId/organization_memberships.json"
            }
        }

        'OrganizationId' {
            $path = "/api/v2/organizations/$OrganizationId/organization_memberships.json"
        }

        default {
            $path = '/api/v2/organization_memberships.json'
        }
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand $key

}

