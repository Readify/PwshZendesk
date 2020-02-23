
function Set-GroupMembershipAsDefault {
    <#
    .SYNOPSIS
        Sets the supplied Group Membership as the default membership for the supplied user.
    .DESCRIPTION
        Sets the supplied Group Membership as the default membership for the supplied user.
    .EXAMPLE
        PS C:\> Set-ZendeskGroupMembershipAsDefault -UserId 1 -Id 2

        Makes the group membership with id 2 the default for the user with id 1. Not that `Id` is the Id of the membership and not the group.
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of User to set default group membership for
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [ValidateNotNullOrEmpty()]
        [Int64[]]
        $UserId,

        # Unique Id of group membership to make default
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

    $path = "/api/v2/users/$UserId/group_memberships/$Id/make_default.json"

    if ($PSCmdlet.ShouldProcess($UserId, "Set default group: $Id")) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
