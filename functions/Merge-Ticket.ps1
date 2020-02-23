
function Merge-Ticket {
    <#
    .SYNOPSIS
        Merges one or more tickets into the ticket with the specified id.
    .DESCRIPTION
        Merges one or more tickets into the ticket with the specified id. Additional requirements can be found at: https://support.zendesk.com/hc/en-us/articles/203690916
    .EXAMPLE
        PS C:\> Merge-ZendeskTicket -SourceTicketId 1 -TargetTicketId 2

        Merges ticket with id 1 into ticket with id 2.
    .EXAMPLE
        PS C:\> Merge-ZendeskTicket -SourceTicketId 1 -TargetTicketId 2 -SourceTicketComment $sourceComment -TargetTicketComment $targetComment

        Merges ticket with id 1 into ticket with id 2 supplying specific comments to be left on each ticket.
    .EXAMPLE
        PS C:\> Merge-ZendeskTicket -Context $context -SourceTicketId 1 -TargetTicketId 2

        Merges ticket with id 1 into ticket with id 2 with connection context from `Get-ZendeskConnection`.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of the ticket or tickets to merge into target ticket
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64[]]
        $SourceTicketId,

        # Unique Id of the ticket to merge source tickets into.
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $TargetTicketId,

        # Private comment to leave on the source tickets.
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SourceTicketComment,

        #  Private comment to leave on the target ticket.
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TargetTicketComment,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    if (-not $PSBoundParameters.ContainsKey('SourceTicketComment')) {
        $SourceTicketComment = "This request was closed and merged into request #$TargetTicketId"
    }

    if (-not $PSBoundParameters.ContainsKey('TargetTicketComment')) {
        if ($SourceTicketId.Count -gt 1) {
            $ids = $SourceTicketId -join ' #'
            $TargetTicketComment = "Requests #$ids were closed and merged into this request."
        } else {
            $TargetTicketComment = "Request #$SourceTicketId was closed and merged into this request."
        }
    }

    $path = "/api/v2/tickets/$TargetTicketId/merge.json"
    $body = @{
        ids            = $SourceTicketId
        target_comment = $TargetTicketComment
        source_comment = $SourceTicketComment
    }

    if ($PSCmdlet.ShouldProcess("$SourceTicketId => $TargetTicketId", 'Merge tickets.')) {
        $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
