
function Get-SearchCount {

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

    Write-Debug -Message "Query: $Query"
    $Query = [uri]::EscapeDataString($Query)
    Write-Debug -Message "Escaped Query: $Query"

    $results = Invoke-Method -Context $Context -Path "/api/v2/search/count.json?query=$Query" -Pagination $false
    $results | Select-Object -Expand 'count'

}
