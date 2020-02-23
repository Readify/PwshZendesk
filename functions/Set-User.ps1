
function Set-User {

    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (

        # User Object to set
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Object')]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]]
        $User,

        # The user's primary email address.
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Properties')]
        [ValidatePattern('@')]
        [String]
        $Email,

        # The user's name.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        # An alias displayed to end users.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Alias,

        # A custom role if the user is an agent on the Enterprise plan.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $CustomRoleId,

        # Any details you want to store about the user.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Details,

        # A unique identifier from another system.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ExternalId,

        # The user's locale.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Locale,

        # The user's language identifier.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $LocaleId,

        # Designates whether the user has forum moderation capabilities.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [Boolean]
        $Moderator,

        # Any notes you want to store about the user.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Notes,

        # If the user can only create private comments.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [Boolean]
        $OnlyPrivateComments,

        # The id of the user's organization.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $OrganizationId,

        # The id of the user's default group.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $DefaultGroupId,

        # The user's primary phone number.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Phone,

        # The user's profile picture represented as an Attachment object.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $Photo,

        # If the agent has any restrictions.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [Boolean]
        $RestrictedAgent,

        # The user's role.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Role,

        # The user's signature.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Signature,

        # If the agent is suspended.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [Boolean]
        $Suspended,

        # The user's tags.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Tags,

        # Specifies which tickets the user has access to.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [String]
        $TicketRestriction,

        # The user's time zone.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [String]
        $TimeZone,

        # Values of custom fields in the user's profile.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [HashTable]
        $UserFields,

        # The user's primary identity is verified or not.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [Boolean]
        $Verified,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    if ($PSCmdlet.ParameterSetName -eq 'Properties') {

        $path = '/api/v2/users/create_or_update.json'
        $body = @{
            user = @{
                email = $Email
            }
        }

        $map = @{
            name                  = 'Name'
            alias                 = 'Alias'
            custom_role_id        = 'CustomRoleId'
            details               = 'Details'
            external_id           = 'ExternalId'
            locale                = 'Locale'
            locale_id             = 'LocaleId'
            moderator             = 'Moderator'
            notes                 = 'Notes'
            only_private_comments = 'OnlyPrivateComments'
            organization_id       = 'OrganizationId'
            default_group_id      = 'DefaultGroupId'
            phone                 = 'Phone'
            photo                 = 'Photo'
            restricted_agent      = 'RestrictedAgent'
            role                  = 'Role'
            signature             = 'Signature'
            suspended             = 'Suspended'
            tags                  = 'Tags'
            ticket_restriction    = 'TicketRestriction'
            time_zone             = 'TimeZone'
            user_fields           = 'UserFields'
            verified              = 'Verified'
        }

        foreach ($item in $map.GetEnumerator()) {
            $property = $item.key
            $parameter = $item.value
            if ($PSBoundParameters.ContainsKey($parameter)) {
                $body.user[$property] = $PSBoundParameters.$parameter
            }
        }

    } else {

        if ($User.count -gt 1) {
            $path = '/api/v2/users/create_or_update_many.json'
            $body = @{
                users = $User
            }
        } else {
            $path = '/api/v2/users/create_or_update.json'
            $body = @{
                user = $User[0]
            }
        }

    }

    if ($PSCmdlet.ShouldProcess('Set Users')) {
        $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
