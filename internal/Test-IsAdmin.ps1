function Test-IsAdmin {
    <#
    .SYNOPSIS
        Tests if the current user is an admin.
    .DESCRIPTION
        Tests if the current user is an admin.
    .EXAMPLE
        PS C:\> Test-IsAdmin -Context $Context

        Returns `$true` if the current user is an admin or `$false` otherwise.
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

    $Context.User.Role -eq 'admin'

}
