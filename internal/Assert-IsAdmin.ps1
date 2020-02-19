function Assert-IsAdmin {
    <#
    .SYNOPSIS
        Asserts that the current user is an admin.
    .DESCRIPTION
        Asserts that the current user is an admin.
    .EXAMPLE
        PS C:\> Assert-IsAdmin -Context $Context

        Raises and exception if current user is not an admin
    #>
    [CmdletBinding()]
    Param (
        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    if (-not (Test-IsAdmin -Context $Context)) {
        throw ($Script:InvalidRoleMessage -f 'admin', $Context.User.Role)
    }

}
