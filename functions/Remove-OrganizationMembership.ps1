
function Remove-OrganizationMembership {

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (

        # Unique Id of the organization membership to remove
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [ValidateNotNullOrEmpty()]
        [Int64[]]
        $Id,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    if ($Id.count -gt 1) {
        $ids = $Id -join ','
        $path = "/api/v2/organization_memberships/destroy_many.json?ids=$ids"
    } else {
        $path = "/api/v2/organization_memberships/$Id.json"
    }

    if ($PSCmdlet.ShouldProcess("$Id", 'Delete Organization Membership')) {
        $result = Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
