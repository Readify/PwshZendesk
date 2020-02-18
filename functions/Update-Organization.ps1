
function Update-Organization {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    if ($PSCmdlet.ShouldProcess('Update-Organization')) {
        throw [System.NotImplementedException]::new()
    }

}
