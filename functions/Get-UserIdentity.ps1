
function Get-UserIdentity {
    <#
    .SYNOPSIS
        Returns user identities for a given user id.
    .DESCRIPTION
        Returns all user identities for a given user id or shows the identity with the given id.
    .EXAMPLE
        PS C:\> Get-UserIdentity -UserId `427427011998`

        Gets all User Identities for the User with Id `427427011998`
    .EXAMPLE
        PS C:\> Get-UserIdentity -UserId `427427011998` -Id `211258542687`

        Gets the User Identity `211258542687` for the User with Id `427427011998`
    .EXAMPLE
        PS C:\> Get-UserIdentity -UserId `427427011998` -Context $context

        Gets all User Identities for the User with Id `427427011998` providing the optional Zendesk Context `$context`
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Unique Id of the user identity to retrieve
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Unique Id of the user to retrieve identities for
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

    if ($PSBoundParameters.ContainsKey('Id')) {
        $path = "/api/v2/users/$UserId/identities/$Id.json"
        $key = 'identity'
    } else {
        $path = "/api/v2/users/$UserId/identities.json"
        $key = 'identities'
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand $key

}
