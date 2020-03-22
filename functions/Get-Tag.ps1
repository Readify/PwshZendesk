
function Get-Tag {
    <#
    .SYNOPSIS
        Gets tags
    .DESCRIPTION
        Gets popular tags, or tags on a ticket, organization, or user. Tags can also be retrieved by partial name.
    .EXAMPLE
        PS C:\> Get-ZendeskTag

        Gets 500 most popular tags
    .EXAMPLE
        PS C:\> Get-ZendeskTag -TicketId 1

        Gets tags on ticket with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskTag -OrganizationId 1

        Gets tags on organization with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskTag -UserId 1

        Gets tags on user with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskTag -PartialName 'Del'

        Gets tags that start with 'Del'
    .EXAMPLE
        PS C:\> Get-ZendeskTag -Context $context

        Gets 500 most popular tags with a connection context from `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param (
        # Unique Id of the ticket to get tags for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Ticket')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $TicketId,

        # Unique Id of the organization to get tags for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Org')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $OrganizationId,

        # Unique Id of the user to get tags for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'User')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Partial Name for auto complete results
        [Parameter(Mandatory = $true,
            ParameterSetName = 'AutoComplete')]
        [ValidateNotNullOrEmpty()]
        [String]
        $PartialName,

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

        'AutoComplete' {
            $path = "/api/v2/autocomplete/tags.json?name=$PartialName"
        }

        default {
            Assert-IsAdmin -Context $Context
            $path = '/api/v2/tags.json'
        }
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand 'tags'

}
