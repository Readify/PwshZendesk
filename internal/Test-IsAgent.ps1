function Test-IsAgent {
    <#
    .SYNOPSIS
        Tests if the current user is an agent.
    .DESCRIPTION
        Tests if the current user is an agent.
    .EXAMPLE
        PS C:\> Test-IsAgent -Context $Context

        Returns `$true` if the current user is an agent or `$false` otherwise.
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

    $Context.User.Role -eq 'agent'

}
