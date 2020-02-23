
function Get-AuthenticatedUser {
    <#
    .SYNOPSIS
        Gets the user record for the authenticated user.
    .DESCRIPTION
        Gets the user record for the authenticated user.
    .EXAMPLE
        PS C:\> Get-ZendeskAuthenticatedUser

        Gets the user record for the authenticated user.
    .EXAMPLE
        PS C:\> Get-ZendeskAuthenticatedUser -Context $context

        Gets the user record for the authenticated user with a connection context returned by `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $result = Invoke-Method -Context $Context -Path "/api/v2/users/me.json" -Verbose:$VerbosePreference
    $result | Select-Object -Expand 'user'

}
