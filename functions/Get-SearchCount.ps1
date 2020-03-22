
function Get-SearchCount {
    <#
    .SYNOPSIS
        Retrieves the number of results a search would return.
    .DESCRIPTION
        Retrieves the number of results a search would return.
    .EXAMPLE
        PS C:\> Get-ZendeskSearchCount -Query 'type:ticket status:open'

        Gets the number of open tickets.
    .EXAMPLE
        PS C:\> Get-ZendeskSearchCount -Query 'status<solved requester:user@domain.com type:ticket'

        Gets the number of unsolved tickets raised by user@domain.com
    #>
    [OutputType([String])]
    [CmdletBinding()]
    Param (
        # Zendesk Query
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Query,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    Write-Debug -Message "Query: $Query"
    $Query = [uri]::EscapeDataString($Query)
    Write-Debug -Message "Escaped Query: $Query"

    $results = Invoke-Method -Context $Context -Path "/api/v2/search/count.json?query=$Query" -Pagination $false
    $results | Select-Object -Expand 'count'

}
