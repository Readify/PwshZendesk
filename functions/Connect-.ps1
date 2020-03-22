
function Connect- {
    <#
    .SYNOPSIS
        Connects to a Zendesk instance.
    .DESCRIPTION
        Connects to a Zendesk instance. Overriding any existing connection established previously with this function.
    .EXAMPLE
        PS C:\> Connect-Zendesk -Organization 'company' -Username 'name@company.net' -ApiKey $ApiKey

        Connects to the 'company' Zendesk instance as the user 'name@company.net'
    #>
    [OutputType([Boolean])]
    [CmdletBinding()]
    Param (
        # Zendesk subdomain
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Organization,

        # Email address of user to log in
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Username,

        # Zendesk API token retrieved from https://<organization>.zendesk.com/agent/admin/api/settings
        [Parameter(Mandatory = $true)]
        [Alias('ApiKey')]
        [ValidateNotNullOrEmpty()]
        [SecureString]
        $ApiToken
    )

    $Script:Context = Get-Connection @PSBoundParameters

    $true

}
