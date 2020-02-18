
function Import-Ticket {

    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (

        # Full ticket object to import
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]]
        $Ticket,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAdmin -Context $Context

    if ($Ticket.count -gt 1) {
        $path = '/api/v2/imports/tickets/create_many.json'
        $body = @{
            tickets = $Ticket
        }
    } else {
        $path = '/api/v2/imports/tickets.json'
        $body = @{
            ticket = $Ticket[0]
        }
    }

    $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
    $result

}
