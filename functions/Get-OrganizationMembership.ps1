
function Get-OrganizationMembership {

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param (

        # Unique Id of the organization membership to retrieve
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Id')]
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

    $key = 'organization_memberships'

    switch ($PSCMDlet.ParameterSetName) {
        'Id' {
            $path = "/api/v2/organization_memberships/$Id.json"
            $key = 'organization_membership'
        }

        'UserId' {
            $path = "api/v2/users/$UserId/organization_memberships.json"
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

