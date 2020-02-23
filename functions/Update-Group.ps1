
function Update-Group {
    <#
    .SYNOPSIS
        Update the name of a Group
    .DESCRIPTION
        Update the name of a Group
    .EXAMPLE
        PS C:\> Update-ZendeskGroup -Id 1 -Name 'Products'

        Updates the name of group with id `1` to be `Products`
    .EXAMPLE
        PS C:\> Update-ZendeskGroup -Context $context -Id 1 -Name 'Products'

        Updates the name of group with id `1` to be `Products` using a `$context` retrieved from `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of the group to update
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # The new name of the group.
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Properties')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAdmin -Context $Context

    $path = "/api/v2/groups/$Id.json"
    $body = @{
        group = @{
            name = $Name
        }
    }

    if ($PSCmdlet.ShouldProcess($Id, 'Update Group Name.')) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
