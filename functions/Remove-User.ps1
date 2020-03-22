
function Remove-User {
    <#
    .SYNOPSIS
        Deletes a user.
    .DESCRIPTION
        Deletes a user by Id or External Id.
    .EXAMPLE
        PS C:\> Remove-ZendeskUser -Id 1

        Soft deletes a user with id 1
    .EXAMPLE
        PS C:\> Remove-ZendeskUser -Id 1, 2, 3

        Soft deletes users with ids 1, 2, and 3
    .EXAMPLE
        PS C:\> Remove-ZendeskUser -ExternalId 1

        Soft deletes a user with external id 1
    .EXAMPLE
        PS C:\> Remove-ZendeskUser -Id 1 -Permanent

        Permanently deletes an already soft deleted user with id 1
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', DefaultParameterSetName = 'Id')]
    Param (
        # Unique Id of the user to delete
        [Parameter(Mandatory = $true, ParameterSetName = 'Id')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64[]]
        $Id,

        # Unique Id of the user to delete
        [Parameter(Mandatory = $true, ParameterSetName = 'ExternalId')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $ExternalId,

        # Permanently delete soft deleted user
        [Parameter(Mandatory = $false, ParameterSetName = 'Id')]
        [Switch]
        $Permanent,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    if ($PSCmdlet.ParameterSetName -eq 'Id') {
        if ($Permanent) {
            if ($Id.count -eq 1) {
                $path = "/api/v2/deleted_users/$Id.json"
            } else {
                throw 'Can only permanently delete one user at a time.'
            }
        } else {
            if ($Id.count -gt 1) {
                Assert-IsAdmin -Context $Context
                $ids = $Id -join ','
                $path = "/api/v2/users/destroy_many.json?ids=$ids"
            } else {
                $path = "/api/v2/users/$Id.json"
            }
        }
    } else {
        Assert-IsAdmin -Context $Context
        $ids = $ExternalId -join ','
        $path = "/api/v2/users/destroy_many.json?external_ids=$ids"
    }

    if ($PSCmdlet.ShouldProcess($Id, 'Delete User')) {
        $result = Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
