
function Remove-UserIdentity {
    <#
    .SYNOPSIS
        Delete the specified User Identity
    .DESCRIPTION
        Delete the specified User Identity
    .EXAMPLE
        PS C:\> Remove-ZendeskUserIdentity -UserId `427427011998` -Id `211258542687`

        Deletes the User Identity `211258542687` for the User with Id `427427011998`
    .EXAMPLE
        PS C:\> Remove-ZendeskUserIdentity -Context $context -UserId `427427011998` -Id `211258542687`

        Deletes the User Identity `211258542687` for the User with Id `427427011998` specifying the optional Context
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of the user identity to delete
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Unique Id of the user whose identity is to be deleted
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

    Assert-IsAgent -Context $Context

    $path = "/api/v2/users/$UserId/identities/$Id.json"

    if ($PSCmdlet.ShouldProcess($Id, 'Delete User Identity')) {
        $result = Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
