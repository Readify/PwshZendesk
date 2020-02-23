
function New-Group {
    <#
    .SYNOPSIS
        Creates a group
    .DESCRIPTION
        Creates a group with the given name.
    .EXAMPLE
        PS C:\> New-ZendeskGroup -Name 'Products'

        Creates a group with the name `Products`
    .EXAMPLE
        PS C:\> New-ZendeskGroup -Context $context -Name 'Products'

        Creates a group with the name 'Products' using a connection context returned by `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # The name of the group.
        [Parameter(Mandatory = $true)]
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

    $path = '/api/v2/groups.json'
    $body = @{
        group = @{
            name = $Name
        }
    }

    if ($PSCmdlet.ShouldProcess($Name, 'Create Group')) {
        $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
