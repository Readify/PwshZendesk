
function Get-SuspendedTicket {
    <#
    .SYNOPSIS
        Retrieves one or more suspended tickets
    .DESCRIPTION
        Retrieves one or more suspended tickets
    .EXAMPLE
        PS C:\> Get-ZendeskSuspendedTicket

        Gets all suspended tickets.
    .EXAMPLE
        PS C:\> Get-ZendeskSuspendedTicket -Id 1

        Gets suspended ticket with id 1.
    .EXAMPLE
        PS C:\> Get-ZendeskSuspendedTicket -Context $context

        Gets all suspended tickets with connection context from `Get-ZendeskConnection`.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Unique Id of the suspended ticket to retrieve
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    if ($PSBoundParameters.containsKey('Id')) {
        $path = "/api/v2/suspended_tickets/$Id.json"
        $key = 'suspended_ticket'
    } else {
        $path = '/api/v2/suspended_tickets.json'
        $key = 'suspended_tickets'
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand $key

}
