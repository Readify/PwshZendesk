
function Remove-Group {

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param (

        # Unique Id of group to delete
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

    $path = "/api/v2/groups/$Id.json"

    if ($PSCmdlet.ShouldProcess($Id, "Delete Group")) {
        $result = Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
