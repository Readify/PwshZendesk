
function Set-UserIdentityAsVerified {
    <#
    .SYNOPSIS
        Sets the specified identity as verified.
    .DESCRIPTION
        Sets the specified identity as verified.
    .EXAMPLE
        PS C:\> Set-UserIdentityAsVerified -UserId `427427011998` -Id `211258542687`

        Sets the User Identity `211258542687` for the User with Id `427427011998` as verified
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of the user identity to mark as verified
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

    $path = "/api/v2/users/$UserId/identities/$Id/verify"

    if ($PSCmdlet.ShouldProcess('Set User Identity as Verified', $Id)) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
