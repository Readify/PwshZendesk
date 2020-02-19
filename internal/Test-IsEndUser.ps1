function Test-IsEndUser {
    <#
    .SYNOPSIS
        Tests if the current user is an end user.
    .DESCRIPTION
        Tests if the current user is an end user.
    .EXAMPLE
        PS C:\> Test-IsEndUser -Context $Context

        Returns `$true` if the current user is an end user or `$false` otherwise.
    #>
    [CmdletBinding()]
    Param (
        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    # Determine the context
    if ($null -eq $Context) {
        if (Test-Path Variable:\Script:Context) {
            $Context = $Script:Context
        } else {
            throw $Script:NotConnectedMessage
        }
    }

    $Context.User.Role -eq 'end-user'

}
