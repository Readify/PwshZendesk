
function Test-Connection {
    <#
    .Synopsis
        Tests the validity of a supplied or stored Zendesk connection.
    .DESCRIPTION
        Tests the validity of a supplied or stored Zendesk connection. Updating the stored information on the current user.
    .EXAMPLE
        if (Test-ZendeskConnection -Context $Context) {
            Search-Zendesk @searchParams
        }

        Tests the connection to Zendesk before making a call to `Search-Zendesk`
    #>
    [OutputType([Boolean])]
    [CmdletBinding()]
    Param(
        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $Context.User = Get-AuthenticatedUser -Context $Context
    $true

}
