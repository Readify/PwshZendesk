
function Update-UserIdentity {
    <#
    .SYNOPSIS
        Updates an identity on a user's profile.
    .DESCRIPTION
        Updates an identity on a user's profile.
    .EXAMPLE
        PS C:\> Update-UserIdentity -UserId 427427011998 -Id 899110724724 -Value 'username@company.com'

        Updates the email address `username@company.com` for the user identity `899110724724` on user `427427011998`
    .EXAMPLE
        PS C:\> Update-UserIdentity -UserId 427427011998 -Id 899110724724 -Verified

        Marks the user identity `899110724724` on user `427427011998` as verified
    .EXAMPLE
        PS C:\> Update-UserIdentity -Context $context -UserId 427427011998 -Id 899110724724 -Value 'username@company.com'

        Updates the email address `username@company.com` for the user identity `899110724724` on user `427427011998` using a Zendesk Context returned from `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', DefaultParameterSetName = 'Default')]
    Param (
        # The id of the user
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Unique Id of the user identity to delete
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # The identifier for this identity, such as an email address
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Value,

        # If the identity has been verified
        [Parameter(Mandatory = $true, ParameterSetName = 'Verified')]
        [Switch]
        $Verified,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    $path = "/api/v2/users/$UserId/identities/$Id.json"

    $body = @{
        identity = @{
            user_id = $UserId
            id      = $Id
        }
    }

    if ($PSBoundParameters.ContainsKey('Value')) {
        $body.identity.value= $Value
    }

    if ($Verified) {
        $body.identity.verified = $true
    }

    if ($PSCmdlet.ShouldProcess($Value, 'Add User Identity')) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
