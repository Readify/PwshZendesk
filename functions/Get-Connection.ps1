
function Get-Connection {
    <#
    .SYNOPSIS
        Returns a Zendesk connection context
    .DESCRIPTION
        Returns an object describing a connection to a Zendesk instance
    .EXAMPLE
        PS C:\> $context = Get-ZendeskConnection -Organization 'company' -Username 'name@company.net' -ApiKey $ApiKey

        Sets $context to a connection context for the 'company' Zendesk instance as the user 'name@company.net'
    #>
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

        # Zendesk API token retrieved from https://<organization>.zendesk.com/agent/admin/api/settings
        [Parameter(Mandatory = $true)]
        [Alias('ApiKey')]
        [ValidateNotNullOrEmpty()]
        [SecureString]
        $ApiToken
    )

    $context = [PSCustomObject]@{
        Organization = $Organization
        BaseUrl      = "https://$Organization.zendesk.com"
        Credential   = [System.Management.Automation.PSCredential]::New("$Username/token", $ApiToken)
        User         = $null
    }

    $context | Add-Member -TypeName 'ZendeskContext'

    if (-not (Test-Connection -context $context)) {
        throw $Script:InvalidConnection
    }

    $context

}
