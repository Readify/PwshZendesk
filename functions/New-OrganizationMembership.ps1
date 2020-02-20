
function New-OrganizationMembership {

    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (

        # The ID of the user for whom this memberships belongs
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Properties')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # he ID of the organization associated with this user, in this membership
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Properties')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $OrganizationId,

        # Denotes whether this is the default organization membership for the user.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [Switch]
        $Default,

        # Full Membership objects
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Object')]
        [PSCustomObject]
        $Membership,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    if ($PSCmdlet.ParameterSetName -eq 'Properties')  {
        $path = '/api/v2/organization_memberships.json'
        $body = @{
            group_membership = @{
                user_id         = $UserId
                organization_id = $OrganizationId
                default         = $Default
            }
        }
    } else {
        $path = '/api/v2/organization_memberships/create_many.json'
        $body = @{
            group_memberships = @($Membership)
        }
    }

    if ($PSCmdlet.ShouldProcess($UserId, "Assign to Org: $OrganizationId")) {
        $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
