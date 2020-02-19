function Assert-IsAgent {
    <#
    .SYNOPSIS
        Asserts that the current user is an agent or admin.
    .DESCRIPTION
        Asserts that the current user is an agent or admin.
    .EXAMPLE
        PS C:\> Assert-IsAgent -Context $Context

        Raises and exception if current user is not an agent or an admin
    #>
    [CmdletBinding()]
    Param (
        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    if (-not (Test-IsAgent -Context $Context) -and -not (Test-IsAdmin -Context $Context)) {
        throw ($Script:InvalidRoleMessage -f 'agent/admin', $Context.User.Role)
    }

}
