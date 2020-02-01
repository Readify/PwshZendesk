
function Update-Group {

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
