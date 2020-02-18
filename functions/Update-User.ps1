
function Update-User {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    if ($PSCmdlet.ShouldProcess('Update-User')) {
        throw [System.NotImplementedException]::new()
    }

}
