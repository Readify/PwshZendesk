
function Search- {
    <#
    .Synopsis
        Searches Zendesk.
    .DESCRIPTION
        Searches Zendesk using the universal search api. See: https://developer.zendesk.com/rest_api/docs/support/search#query-basics
    .EXAMPLE
        PS C:\> Search-Zendesk -Query 'type:ticket status:open'

        Searched for open tickets
    .EXAMPLE
        PS C:\> Search-Zendesk -Query 'status<solved requester:user@domain.com type:ticket'

        Searched for unsolved tickets requested by user@domain.com
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    Param (
        # Zendesk Search Query
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

    $results = Invoke-Method -Context $Context -Path "/api/v2/search.json?query=$Query" -Verbose:$VerbosePreference
    $results.results

}
