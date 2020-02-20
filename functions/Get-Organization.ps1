function Get-Organization {
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
