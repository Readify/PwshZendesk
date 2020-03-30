function New-SatisfactionRating {
    <#
    .SYNOPSIS
        Creates a CSAT rating for a solved ticket, or for a ticket that was previously solved and then reopened.
    .DESCRIPTION
        Creates a CSAT rating for a solved ticket, or for a ticket that was previously solved and then reopened.
    .EXAMPLE
        PS C:\> New-ZendeskSatisfactionRating -TicketId 1 -Score 'good'

        Creates a good satisfaction rating for ticket with id 1
    .EXAMPLE
        PS C:\> New-ZendeskSatisfactionRating -TicketId 1 -Score 'good' -Comment 'fast'

        Creates a good satisfaction rating for ticket with id 1 including a comment.
    .EXAMPLE
        PS C:\> New-ZendeskSatisfactionRating -TicketId 1 -Score 'bad' -ReasonCode 5

        Creates a bad satisfaction rating for ticket with id 1 including a reason for the bad rating.
    .NOTES
        Only the end user listed as the ticket requester can create a satisfaction rating for the ticket.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        # The internal id of the ticket to create a rating for
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $TicketId,

        # The rating
        [Parameter(Mandatory = $true)]
        [ValidateSet('good', 'bad')]
        [String]
        $Score,

        # The comment
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Comment,

        # The reason for a bad rating given by the requester
        [Parameter(Mandatory = $false)]
        [Int]
        $ReasonCode = 0,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsEndUser -Context $Context

    $path = "/api/v2/tickets/$TicketId/satisfaction_rating.json"
    $body = @{
        satisfaction_rating = @{
            score = $Score
        }
    }

    if ($PSBoundParameters.ContainsKey('Comment')) {
        $body.satisfaction_rating.comment = $Comment
    }

    if ($Score -eq 'bad') {
        $body.satisfaction_rating.reason_code = $ReasonCode
    }

    if ($PSCmdlet.ShouldProcess($TicketId, 'Create Group')) {
        $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }
}
