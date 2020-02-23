
function Get-Problem {
    <#
    .SYNOPSIS
        Gets problem tickets.
    .DESCRIPTION
        Gets problem tickets.
    .EXAMPLE
        PS C:\> Get-ZendeskProblem

        Gets problem tickets.
    .EXAMPLE
        PS C:\> Get-ZendeskProblem -PartialSubject 'System'

        Gets problem tickets with the word 'system' in the subject.
    .EXAMPLE
        PS C:\> Get-ZendeskProblem -Context $context

        Gets problem tickets with connection context from `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Partial subject of problem to search for.
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PartialSubject,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    if ($PSBoundParameters.ContainsKey('PartialSubject')) {
        $path = "/api/v2/problems/autocomplete.json?text=$PartialSubject"
        $method = 'Post'
    } else {
        $path = '/api/v2/problems.json'
        $method = 'Get'
    }

    $result = Invoke-Method -Context $Context -Method $method -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand 'tickets'

}
