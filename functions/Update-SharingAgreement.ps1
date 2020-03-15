function Update-SharingAgreement {
    <#
    .SYNOPSIS
        Updates the status of a sharing agreement
    .DESCRIPTION
        Updates the status of a sharing agreement
    .EXAMPLE
        PS C:\> Update-SharingAgreement -Id 1 -Status 'accepted'

        Accepts the sharing agreement with id 1.
    .EXAMPLE
        PS C:\> Update-SharingAgreement -Id 1 -Status 'declined'

        Declines the sharing agreement with id 1.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of the group to retrieve
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Unique Id of the group to retrieve
        [Parameter(Mandatory = $false)]
        [ValidateSet('accepted', 'declined', 'pending', 'inactive')]
        [String]
        $Status,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAdmin -Context $Context

    $path = "/api/v2/sharing_agreements/$Id.json"
    $body = @{
        sharing_agreement = @{
            status = $Status
        }
    }

    if ($PSCmdlet.ShouldProcess($Id, 'Update Group Name.')) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }
}
