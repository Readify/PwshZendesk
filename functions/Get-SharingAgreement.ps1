function Get-SharingAgreement {
    <#
    .SYNOPSIS
        Returns a sharing agreement for your account.
    .DESCRIPTION
        Returns a sharing agreement for your account.
    .EXAMPLE
        PS C:\> Get-ZendeskSharingAgreement

        Lists all sharing agreements
    .EXAMPLE
        PS C:\> Get-ZendeskSharingAgreement -Id 1

        Gets the details of the sharing agreement with id 1
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param (

        # Unique Id of the group to retrieve
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    if ($PSBoundParameters.ContainsKey('Id')) {
        $path = "/api/v2/sharing_agreements/$Id.json"
        $key = 'sharing_agreement'
    } else {
        $path = '/api/v2/sharing_agreements.json'
        $key = 'sharing_agreements'
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand $key
}
