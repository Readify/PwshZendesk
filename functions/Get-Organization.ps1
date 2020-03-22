function Get-Organization {
    <#
    .SYNOPSIS
        Gets organizations
    .DESCRIPTION
        Gets all organizations or by id, external id, user id, or partial name
    .EXAMPLE
        PS C:\> Get-ZendeskOrganization

        Gets all organizations.
    .EXAMPLE
        PS C:\> Get-ZendeskOrganization -Id 1

        Gets organization with id 1.
    .EXAMPLE
        PS C:\> Get-ZendeskOrganization -Id 1, 2, 3

        Gets organizations with ids 1, 2, and 3.
    .EXAMPLE
        PS C:\> Get-ZendeskOrganization -ExternalId 1

        Gets organization with external id 1
    .EXAMPLE
        PS C:\> Get-ZendeskOrganization -ExternalId 1, 2, 3

        Gets organizations with external ids 1, 2, and 3.
    .EXAMPLE
        PS C:\> Get-ZendeskOrganization -UserId 1

        Gets organizations that user with id 1 is a member of.
    .EXAMPLE
        PS C:\> Get-ZendeskOrganization -PartialName 'Del'

        Gets organizations with names that start with 'Del'.
    .EXAMPLE
        PS C:\> Get-ZendeskOrganization -Context $context

        Gets all organizations with connection context from `Get-ZendeskConnection`.
    #>
    [CmdletBinding(DefaultParameterSetName = 'default')]
    Param (
        # Unique Id of the group to retrieve
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Id')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64[]]
        $Id,

        # External Id of the group to retrieve
        [Parameter(Mandatory = $true,
            ParameterSetName = 'ExternalId')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64[]]
        $ExternalId,

        # Unique Id of the user to retrieve groups for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'UserId')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Partial name to attempt group autocomplete for
        [Parameter(Mandatory = $true,
            ParameterSetName = 'AutoComplete')]
        [ValidateNotNullOrEmpty()]
        [String]
        $PartialName,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    $key = 'organizations'

    switch ($PSCmdlet.ParameterSetName) {
        'Id' {
            if ($Id.count -gt 1) {
                $ids = $Id -join ','
                $path = "/api/v2/organizations/show_many.json?ids=$ids"
            } else {
                $path = "/api/v2/organizations/$Id.json"
                $key = 'organization'
            }
        }

        'ExternalId' {
            if ($ExternalId.count -gt 1) {
                $ids = $ExternalId -join ','
                $path = "/api/v2/organizations/show_many.json?external_ids=$ids"
            } else {
                $path = "/api/v2/organizations/search.json?external_id=$ExternalId"
                $key = 'organization'
            }
        }

        'UserId' {
            $path = "/api/v2/users/$UserId/organizations.json"
        }

        'AutoComplete' {
            $path = "/api/v2/organizations/autocomplete.json?name=$PartialName"
        }

        default {
            $path = '/api/v2/organizations.json'
        }
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand $key
}
