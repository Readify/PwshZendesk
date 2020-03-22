
function Remove-Tag {
    <#
    .SYNOPSIS
        Removes tags from a ticket, organization, or user
    .DESCRIPTION
        Removes tags from a ticket, organization, or user
    .EXAMPLE
        PS C:\> Remove-ZendeskTag -TicketId 1 -Tag 'a'

        Removes tag 'a' from ticket with id 1
    .EXAMPLE
        PS C:\> Remove-ZendeskTag -OrganizationId 1 -Tag 'a'

        Removes tag 'a' from organization with id 1
    .EXAMPLE
        PS C:\> Remove-ZendeskTag -UserId 1 -Tag 'a'

        Removes tag 'a' from user with id 1
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of the ticket to remove tags from
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Ticket')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $TicketId,

        # Unique Id of the organization to remove tags from
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Org')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $OrganizationId,

        # Unique Id of the user to remove tags from
        [Parameter(Mandatory = $true,
            ParameterSetName = 'User')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Tags to remove from the entity
        [Parameter(Mandatory = $true)]
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
        $result = Invoke-Method -Context $Context -Method 'Delete' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
