
function Get-UserRelated {

    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (

        # Unique Id of the user to get related information for
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $result = Invoke-Method -Path "/api/v2/users/$UserId/related.json" -Context $Context -Verbose:$VerbosePreference
    $result

}
