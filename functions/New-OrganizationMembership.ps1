
function New-OrganizationMembership {

    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (

        # The ID of the user for whom this memberships belongs
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # he ID of the organization associated with this user, in this membership
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $OrganizationId,

        # Denotes whether this is the default organization membership for the user.
        [Parameter(Mandatory = $false)]
        [Switch]
        $Default,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = 'api/v2/group_memberships.json'
    $body = @{
        group_membership = @{
            user_id         = $UserId
            organization_id = $OrganizationId
            default         = $Default
        }
    }

    if ($PSCmdlet.ShouldProcess($UserId, "Assign to Org: $OrganizationId")) {
        $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
