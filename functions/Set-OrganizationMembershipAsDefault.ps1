
function Set-OrganizationMembershipAsDefault {

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (

        # Unique Id of user to set default organization for
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [ValidateNotNullOrEmpty()]
        [Int64[]]
        $UserId,

        # Unique Id of organization membership to set as default
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [ValidateNotNullOrEmpty()]
        [Int64[]]
        $MembershipId,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/api/v2/users/$UserId/organization_memberships/$MembershipId/make_default.json"

    if ($PSCmdlet.ShouldProcess($UserId, "Set default Organization Membership: $MembershipId")) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
