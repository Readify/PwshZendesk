
function Hide-Comment {
    <#
    .SYNOPSIS
        Makes a comment private.
    .DESCRIPTION
        Makes a comment private.
    .EXAMPLE
        PS C:\> Hide-ZendeskComment -TicketId 1 -Id 2

        Makes the comment with id 2 on ticket with id 1 private.
    #>
    [OutputType([String])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of the comment to hide
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Unique Id of the ticket the comment resides on
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $TicketId,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    $path = "/api/v2/tickets/$TicketId/comments/$Id/make_private.json"

    if ($PSCmdlet.ShouldProcess($Id, 'Make comment private')) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Verbose:$VerbosePreference
        $result
    }
}
