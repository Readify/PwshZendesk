
function Remove-SharingAgreement {
    <#
    .SYNOPSIS
        Deletes a sharing agreement.
    .DESCRIPTION
        Deletes a sharing agreement.
    .EXAMPLE
        PS C:\> Remove-ZendeskSharingAgreement -Id 1

        Deletes the sharing agreement with Id 1
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of sharing agreement to delete
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAdmin -Context $Context

    $path = "/api/v2/sharing_agreements/$Id.json"

    if ($PSCmdlet.ShouldProcess($Id, "Delete Sharing Agreement")) {
        $result = Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
