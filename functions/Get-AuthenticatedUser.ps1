
function Get-AuthenticatedUser {

    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $result = Invoke-Method -Context $Context -Path "/api/v2/users/me.json" -Verbose:$VerbosePreference
    $result | Select-Object -Expand 'user'

}
