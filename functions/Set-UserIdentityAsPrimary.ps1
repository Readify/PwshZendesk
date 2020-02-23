
function Set-UserIdentityAsPrimary {
    <#
    .SYNOPSIS
        Sets the specified identity as primary.
    .DESCRIPTION
        Sets the specified identity as primary.
    .EXAMPLE
        PS C:\> Set-ZendeskUserIdentityAsPrimary -UserId `427427011998` -Id `211258542687`

        Sets the User Identity `211258542687` for the User with Id `427427011998` as their primary Identity
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of the user identity to make primary
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Unique Id of the user
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    if (Test-IsEndUser -Context $Context) {
        $path = "/api/v2/end_users/$UserId/identities/$Id/make_primary"
    } else {
        $path = "/api/v2/users/$UserId/identities/$Id/make_primary"
    }

    if ($PSCmdlet.ShouldProcess('Set User Identity as Primary', $Id)) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Verbose:$VerbosePreference
        $result
    }
}
