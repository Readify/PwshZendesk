
function Hide-Comment {

    [OutputType([String])]
    [CmdletBinding()]
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

    $path = "/api/v2/tickets/$TicketId/comments/$Id/make_private.json"

    $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Verbose:$VerbosePreference
    $result
}
