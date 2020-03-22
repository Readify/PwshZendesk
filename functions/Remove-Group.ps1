
function Remove-Group {
    <#
    .SYNOPSIS
        Deletes a Group
    .DESCRIPTION
        Deletes a Group
    .EXAMPLE
        PS C:\> Remove-ZendeskGroup -Id 1

        Deletes the group with id `1`
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
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

    Assert-IsAdmin -Context $Context

    $path = "/api/v2/groups/$Id.json"

    if ($PSCmdlet.ShouldProcess($Id, "Delete Group")) {
        $result = Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
