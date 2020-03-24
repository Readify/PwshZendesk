function Get-SatisfactionRating {
    <#
    .SYNOPSIS
        Retrieves Satisfaction Ratings
    .DESCRIPTION
        Retrieves Satisfaction Ratings
    .EXAMPLE
        PS C:\> Get-ZendeskSatisfactionRating

        Retrieves all satisfaction ratings
    .EXAMPLE
        PS C:\> Get-ZendeskSatisfactionRating -Id 1

        Retrieves satisfaction rating with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskSatisfactionRating -Score 'good_with_comment'

        Retrieves all good satisfaction ratings that include a comment
    .EXAMPLE
        PS C:\> Get-ZendeskSatisfactionRating -Score 'good'

        Retrieves all good satisfaction ratings regardless of whether a comment was included
    .EXAMPLE
        PS C:\> Get-ZendeskSatisfactionRating -Score 'received'

        Retrieves all satisfaction ratings that have been received whether the rating is good or bad.
    .EXAMPLE
        PS C:\> Get-ZendeskSatisfactionRating -Score 'offered'

        Retrieves all satisfaction ratings that have been offered but not responded to.
    .EXAMPLE
        PS C:\> Get-ZendeskSatisfactionRating -StartTime [DateTime]::Now.AddHours(-1)

        Retrieves all satisfaction ratings from the past hour.
    .NOTES
        If you specify an unqualified score such as good, the results include all the records with and without comments.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Filter')]
    Param (
        # Unique Id of the satisfaction rating to retrieve
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Id')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Parameter help description
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Filter')]
        [ValidateSet('offered', 'unoffered',
            'received', 'received_with_comment', 'received_without_comment',
            'good', 'good_with_comment', 'good_without_comment',
            'bad', 'bad_with_comment', 'bad_without_comment')]
        [String]
        $Score,

        # Time of the oldest satisfaction rating, as a Unix epoch time
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Filter')]
        [DateTimeOffset]
        $StartTime,

        # Time of the most recent satisfaction rating, as a Unix epoch time
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Filter')]
        [DateTimeOffset]
        $EndTime,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAdmin -Context $Context

    if ($PSBoundParameters.ContainsKey('Id')) {
        $path = "/api/v2/satisfaction_ratings/$Id.json"
        $key = 'satisfaction_rating'
    } else {
        $path = '/api/v2/satisfaction_ratings.json'
        $key = 'satisfaction_ratings'
    }

    $parameters = @()
    if ($PSBoundParameters.ContainsKey('Score')) {
        $parameters += "score=$Score"
    }
    if ($PSBoundParameters.ContainsKey('StartTime')) {
        $parameters += 'start_time={0}' -f $StartTime.ToUnixTimeSeconds()
    }
    if ($PSBoundParameters.ContainsKey('EndTime')) {
        $parameters += 'end_time={0}' -f $EndTime.ToUnixTimeSeconds()
    }
    if ($parameters.Count -gt 0) {
        $path += '?' + $parameters -join '&'
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand $key
}
