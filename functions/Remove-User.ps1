
function Remove-User {

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
