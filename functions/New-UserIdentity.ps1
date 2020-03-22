
function New-UserIdentity {
    <#
    .SYNOPSIS
        Adds a new identity to a user's profile.
    .DESCRIPTION
        Adds a new identity to a user's profile.
    .EXAMPLE
        PS C:\> New-ZendeskUserIdentity -UserId '427427011998 -Type 'email' -Value 'username@company.com'

        Adds the email address `username@company.com` to the user `427427011998`
    .EXAMPLE
        PS C:\> New-ZendeskUserIdentity -UserId '427427011998 -Type 'twitter' -Value 'username'

        Adds the twitter account `username` to the user `427427011998`
    .EXAMPLE
        PS C:\> New-ZendeskUserIdentity -UserId '427427011998 -Type 'facebook' -Value '855769377321'

        Adds the facebook account `855769377321` to the user `427427011998`
    .EXAMPLE
        PS C:\> New-ZendeskUserIdentity -UserId '427427011998 -Type 'google' -Value 'username@gmail.com'

        Adds the google account `username@gmail.com` to the user `427427011998`
    .EXAMPLE
        PS C:\> New-ZendeskUserIdentity -UserId '427427011998 -Type 'phone_number' -Value '+1 555-123-4567'

        Adds the phone_number `+1 555-123-4567` to the user `427427011998`
    .EXAMPLE
        PS C:\> New-ZendeskUserIdentity -UserId '427427011998 -Type 'agent_fowarding' -Value '+1 555-123-4567'

        Adds the agent_fowarding number `+1 555-123-4567` to the user `427427011998`
    .EXAMPLE
        PS C:\> New-ZendeskUserIdentity -UserId '427427011998 -Type 'email' -Value 'username@company.com' -Verified

        Adds the email address `username@company.com` to the user `427427011998` and marks it as verified
    .EXAMPLE
        PS C:\> New-ZendeskUserIdentity -UserId '427427011998 -Type 'email' -Value 'username@company.com' -Primary

        Adds the email address `username@company.com` to the user `427427011998` as their primary identity
    .EXAMPLE
        PS C:\> New-ZendeskUserIdentity -Context $context -UserId '427427011998 -Type 'email' -Value 'username@company.com'

        Adds the email address `username@company.com` to the user `427427011998` using a Zendesk Context returned from `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', DefaultParameterSetName = 'Default')]
    Param (
        # The id of the user
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # The Type of the Identity.
        [Parameter(Mandatory = $true)]
        [ValidateSet('email', 'twitter', 'facebook', 'google', 'phone_number', 'agent_fowarding', 'sdk')]
        [String]
        $Type,

        # The identifier for this identity, such as an email address
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Value,

        # If the identity has been verified
        [Parameter(Mandatory = $true, ParameterSetName = 'Verified')]
        [Switch]
        $Verified,

        # If the identity is the primary identity.
        [Parameter(Mandatory = $false, ParameterSetName = 'Verified')]
        [Switch]
        $Primary,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    if (Test-IsEndUser -Context $Context) {
        $path = "/api/v2/end_users/$UserId/identities.json"
    } else {
        $path = "/api/v2/users/$UserId/identities.json"
    }

    $body = @{
        identity = @{
            user_id  = $UserId
            type     = $Type
            value    = $Value
            verified = [Boolean]$Verified
            primary  = [Boolean]$Primary
        }
    }

    if ($PSCmdlet.ShouldProcess($Value, 'Add User Identity')) {
        $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
