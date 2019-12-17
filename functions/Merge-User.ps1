
function Merge-User {

    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true)]
    Param (

        # Unique Id of the user to merge
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Unique Id of the user to merge into
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $TargetUserId,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/api/v2/users/$UserId/merge.json"
    $body = @{
        user = @{
            id = $TargerUserId
        }
    }

    if ($PSCmdlet.ShouldProcess("$UserId => $TargetUserId", 'Merge user.')) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
