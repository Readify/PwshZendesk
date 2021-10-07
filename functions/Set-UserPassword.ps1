
function Set-UserPassword {
    <#
    .SYNOPSIS
        Sets the specified identity as verified.
    .DESCRIPTION
        Sets the specified identity as verified.
    .EXAMPLE
        PS C:\> Set-ZendeskUserIdentityAsVerified -UserId `427427011998` -Id `211258542687`

        Sets the User Identity `211258542687` for the User with Id `427427011998` as verified
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of the user
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        [Parameter(Mandatory = $true)]
        [SecureString]
        $NewPassword,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAdmin -Context $Context

    $path = "/api/v2/users/$UserId/password.json"

    $body = @{
        password = $NewPassword | ConvertFrom-SecureString -AsPlainText
    }

    if ($PSCmdlet.ShouldProcess('Set User Identity as Verified', $UserId)) {
        $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
