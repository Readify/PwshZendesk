
function Get-Connection {

    [OutputType([PSCustomObject])]
    [CMDletBinding()]
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

    $context = [PSCustomObject]@{
        Organization = $Organization
        BaseUrl      = "https://$Organization.zendesk.com"
        Credential   = [System.Management.Automation.PSCredential]::New("$Username/token", $ApiKey)
    }

    $context | Add-Member -TypeName 'ZendeskContext'
    $context

}
