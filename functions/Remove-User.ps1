
function Remove-User {

    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (

        # Unique Id of the user to delete
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Permanently delete soft deleted user
        [Parameter(Mandatory = $false)]
        [Switch]
        $Permanent,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    if ($Permanent) {
        $path = "/api/v2/deleted_users/$UserId.json"
    } else {
        $path = "/api/v2/users/$UserId.json"
    }

    if ($PSCmdlet.ShouldProcess($UserId, 'Delete User')) {
        $result = Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
