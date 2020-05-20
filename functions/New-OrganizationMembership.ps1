
function New-OrganizationMembership {
    <#
    .SYNOPSIS
        Assigns a user to a given organization.
    .DESCRIPTION
        Assigns a user to a given organization.
    .EXAMPLE
        PS C:\> New-ZendeskOrganizationMembership -UserId 1 -OrganizationId 2

        Assigns the user with id 1 to a the organization with id 2.
    .EXAMPLE
        PS C:\> New-ZendeskOrganizationMembership -UserId 1 -OrganizationId 2 -Default

        Assigns the user with id 1 to a the organization with id 2 and makes it the default membership.
    .EXAMPLE
        PS C:\> New-ZendeskOrganizationMembership -Membership @{ UserId = 1; OrganizationId = 2 }

        Assigns the user with id 1 to a the organization with id 2.
    .EXAMPLE
        PS C:\> New-ZendeskOrganizationMembership -Membership @( @{ UserId = 1; OrganizationId = 2 }, @{ UserId = 1; OrganizationId = 3 } )

        Assigns the user with id 1 to a the organizations with ids 2 and 3.
    .EXAMPLE
        PS C:\> New-ZendeskOrganizationMembership -Membership @{ UserId = 1; OrganizationId = 2; Default = $true }

        Assigns the user with id 1 to a the organization with id 2.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # The ID of the user for whom this memberships belongs
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Properties')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # he ID of the organization associated with this user, in this membership
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Properties')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $OrganizationId,

        # Denotes whether this is the default organization membership for the user.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [Switch]
        $Default,

        # Full Membership objects
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Object')]
        [PSCustomObject[]]
        $Membership,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    if ($PSCmdlet.ParameterSetName -eq 'Properties')  {
        $path = '/api/v2/organization_memberships.json'
        $body = @{
            organization_membership = @{
                user_id         = $UserId
                organization_id = $OrganizationId
                default         = $Default
            }
        }
    } else {
        $path = '/api/v2/organization_memberships/create_many.json'
        $body = @{
            organization_memberships = @($Membership)
        }
    }

    if ($PSCmdlet.ShouldProcess($UserId, "Assign to Org: $OrganizationId")) {
        $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
