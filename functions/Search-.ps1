
function Search- {
    <#
    .Synopsis
    Searches Zendesk.
    .DESCRIPTION
    Searches Zendesk using the universal search api.
    .EXAMPLE
    Search-Zendesk -Query 'type:user user@company.com'
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

    Write-Debug -Message "Query: $Query"
    $Query = [uri]::EscapeDataString($Query)
    Write-Debug -Message "Escaped Query: $Query"

    $results = Invoke-Method -Context $Context -Path "/api/v2/search.json?query=$Query"
    $results.results

}
