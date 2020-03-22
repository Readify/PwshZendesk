
function Set-OrganizationMembershipAsDefault {
    <#
    .SYNOPSIS
        Sets the supplied Organization Membership as the default membership for the supplied user.
    .DESCRIPTION
        Sets the supplied Organization Membership as the default membership for the supplied user.
    .EXAMPLE
        PS C:\> Set-ZendeskOrganizationMembershipAsDefault -UserId 1 -Id 2

        Makes the organization membership with id 2 the default for the user with id 1. Not that `Id` is the Id of the membership and not the organization.
    #>
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
        $Id,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    $path = "/api/v2/users/$UserId/organization_memberships/$Id/make_default.json"

    if ($PSCmdlet.ShouldProcess($UserId, "Set default Organization Membership: $Id")) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
