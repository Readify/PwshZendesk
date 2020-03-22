
function Set-Tag {
    <#
    .SYNOPSIS
        Sets the tags for a ticket, organization, or user.
    .DESCRIPTION
        Sets the tags for a ticket, organization, or user. Any tags that are omitted are removed.
    .EXAMPLE
        PS C:\> Set-ZendeskTag -TicketId 1 -Tag 'a', 'b', 'c'

        Sets the tags for ticket with id 1. Any existing tags not specified are removed.
    .EXAMPLE
        PS C:\> Set-ZendeskTag -OrganizationId 1 -Tag 'a', 'b', 'c'

        Sets the tags for organization with id 1. Any existing tags not specified are removed.
    .EXAMPLE
        PS C:\> Set-ZendeskTag -UserId 1 -Tag 'a', 'b', 'c'

        Sets the tags for user with id 1. Any existing tags not specified are removed.
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = 'Default', SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of ticket to set tags for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Ticket')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $TicketId,

        # Unique Id of organization to set tags for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Org')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $OrganizationId,

        # Unique Id of user to set tags for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'User')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Tags to set for the entity. Existing tags not included here will be removed.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Tag,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    switch ($PSCMDlet.ParameterSetName) {
        'Ticket' {
            $path = "/api/v2/tickets/$TicketId/tags.json"
        }

        'Org' {
            $path = "/api/v2/organizations/$OrganizationId/tags.json"
        }

        'User' {
            $path = "/api/v2/users/$UserId/tags.json"
        }
    }

    $body = @{
        tags = $Tag
    }

    if ($PSCmdlet.ShouldProcess("$TicketId$OrganizationId$UserId", "Set Tags: $Tag")) {
        $result = Invoke-Method -Context $Context -Method 'POST' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
