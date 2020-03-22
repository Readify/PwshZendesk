
function Remove-GroupMembership {
    <#
    .SYNOPSIS
        Immediately removes a user from a group.
    .DESCRIPTION
        Immediately removes a user from a group and schedules a job to unassign all working tickets that are assigned to the given user and group combination.
    .EXAMPLE
        PS C:\> Remove-ZendeskGroupMembership -Id 1

        Deletes the group membership with id 1
    .EXAMPLE
        PS C:\> Remove-ZendeskGroupMembership -Id 1 -UserId 2

        Deletes the group membership with id 1 assigned to user with id 2
    .EXAMPLE
        PS C:\> Remove-ZendeskGroupMembership -Id 1, 2, 3

        Deletes the group memberships with ids 1, 2, and 3
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', DefaultParameterSetName = 'default')]
    Param (
        # Unique Id of group membership to remove
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [ValidateNotNullOrEmpty()]
        [Int64[]]
        $Id,

        # The id of the user to remove group membership for
        [Parameter(Mandatory = $true, ParameterSetName = 'UserId')]
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

    if ($PSCmdlet.ParameterSetName -eq 'UserId') {
        if ($Id.count -gt 1) {
            throw 'Only 1 group membership can deleted at a time when explicitly tied to a user.'
        } else {
            $path = "/api/v2/users/$UserId/group_memberships/$Id.json"
        }
    } else {
        if ($Id.count -gt 1) {
            $ids = $Id -join ','
            $path = "/api/v2/group_memberships/destroy_many.json?ids=$ids"
        } else {
            $path = "/api/v2/group_memberships/$Id.json"
        }
    }

    if ($PSCmdlet.ShouldProcess("$Id", 'Delete Group Memberships')) {
        $result = Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
