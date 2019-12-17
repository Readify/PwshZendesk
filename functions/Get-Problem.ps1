
function Get-Problem {

    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = '/api/v2/problems.json'

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand 'tickets'

}
