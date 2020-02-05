
function Connect- {
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

        # Zendesk API key retrieved from https://<organization>.zendesk.com/agent/admin/api/settings
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [SecureString]
        $ApiKey
    )

    $context = Get-Connection @PSBoundParameters

    if (Test-Connection -context $context) {
        $Script:Context = $context
    } else {
        throw $Script:InvalidConnection
    }

    $true

}
