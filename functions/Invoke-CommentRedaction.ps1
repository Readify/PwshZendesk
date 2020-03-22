
function Invoke-CommentRedaction {
    <#
    .SYNOPSIS
        Permanently removes words or strings from a ticket comment.
    .DESCRIPTION
        Permanently removes words or strings from a ticket comment.
    .EXAMPLE
        PS C:\> Invoke-ZendeskCommentRedaction -TicketId 1 -Id 2 -Text 'p@ssword'

        Redacts the text string `p@ssword` in the comment with id 2 that is associated with ticket with id 1
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of the ticket the comment belongs to
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $TicketId,

        # Unique Id of the comment to redact text in
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Text to redact
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Text,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    $path = "/api/v2/tickets/$TicketId/comments/$Id/redact.json"
    $body = @{
        text = $Text
    }

    if ($PSCmdlet.ShouldProcess($Id, 'Redact comment text')) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }
}
