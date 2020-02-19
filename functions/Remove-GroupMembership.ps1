
function Remove-GroupMembership {

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (

        # Unique Id of group membership to remove
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [ValidateNotNullOrEmpty()]
        [Int64[]]
        $Id,

        # The id of the user to remove group membership for
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAdmin -Context $Context

    if ($Id.count -gt 1) {
        $ids = $Id -join ','
        $path = "/api/v2/group_memberships/destroy_many.json?ids=$ids"
    } else {
        if ($PSBoundParameters.ContainsKey('UserId')) {
            $path = "/api/v2/users/$UserId/group_memberships/$Id.json"
        } else {
            $path = "/api/v2/group_memberships/$Id.json"
        }
    }

    if ($PSCmdlet.ShouldProcess("$Id", 'Delete Group Memberships')) {
        $result = Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
