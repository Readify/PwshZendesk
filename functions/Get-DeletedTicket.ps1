
function Get-DeletedTicket {
    <#
    .SYNOPSIS
        Gets deleted tickets.
    .DESCRIPTION
        Gets deleted tickets that are not archived.
    .EXAMPLE
        PS C:\> Get-ZendeskDeletedTicket

        Gets deleted tickets.
    .EXAMPLE
        PS C:\> Get-ZendeskDeletedTicket -Context $context

        Gets deleted tickets using a connection context from `Get-ZendeskConnection.
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

    $path = '/api/v2/deleted_tickets.json'

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand 'deleted_tickets'

}
