function Get-OrganizationRelated {
    <#
    .SYNOPSIS
        Gets the number of users and tickets associated with a supplied organization
    .DESCRIPTION
        Gets the number of users and tickets associated with a supplied organization
    .EXAMPLE
        PS C:\> Get-ZendeskOrganizationRelated -OrganizationId 1

        Gets the number of users and tickets associated with organization with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskOrganizationRelated -Context $context -OrganizationId 1

        Gets the number of users and tickets associated with organization with id 1 with connection context returned by `Get-ZendeskConnection`
    #>
    [CmdletBinding(DefaultParameterSetName = 'default')]
    Param (
        # Unique Id of the group to retrieve
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Id')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64[]]
        $OrganizationId,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    $path = "/api/v2/organizations/$OrganizationId/related.json"

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand 'organization_related'
}
