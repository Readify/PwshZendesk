
function Send-UserIdentityVerification {
    <#
    .SYNOPSIS
        Sends the user a verification email with a link to verify ownership of the email address.
    .DESCRIPTION
        Sends the user a verification email with a link to verify ownership of the email address.
    .EXAMPLE
        PS C:\> Send-UserIdentityVerification -UserId `427427011998` -Id `211258542687`

        Triggers a Zendesk Identity Verification Email for User Identity `211258542687`
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of the user identity to verify
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Unique Id of the user whose identity to verify
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

    $path = "/api/v2/users/$UserId/identities/$Id/request_verification.json"

    if ($PSCmdlet.ShouldProcess('Send a User Identity Verification', $Id)) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
