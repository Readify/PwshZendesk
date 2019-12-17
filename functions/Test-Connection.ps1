
function Test-Connection {
    <#
    .Synopsis
    Checks that api credentials have been stored.
    .DESCRIPTION
    Checks that api credentials have been stored.
    .EXAMPLE
    if (Test-ZendeskConnection) {
        Search-Zendesk @searchParams
    }
    #>
    [OutputType([Bool])]
    [CmdletBinding()]
    Param(
        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $null = Get-AuthenticatedUser -Context $Context
    $true

}
