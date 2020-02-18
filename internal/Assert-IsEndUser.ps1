function Assert-IsEndUser {
    <#
    .SYNOPSIS
        Asserts that the current user is an end user.
    .DESCRIPTION
        Asserts that the current user is an end user.
    .EXAMPLE
        PS C:\> Assert-IsEndUSer -Context $Context

        Raises and exception if current user is not an end user
    #>
    [CmdletBinding()]
    Param (
        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    if (-not (Test-IsEndUser -Context $Context)) {
        throw ($Script:InvalidRoleMessage -f 'end-user', $Context.User.Role)
    }

}
