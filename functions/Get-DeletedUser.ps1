
function Get-DeletedUser {
    <#
    .SYNOPSIS
        Returns deleted users, including permanently deleted users
    .DESCRIPTION
        Returns deleted users, including permanently deleted users
    .EXAMPLE
        PS C:\> Get-ZendeskDeletedUser

        Returns deleted users.
    .EXAMPLE
        PS C:\> Get-ZendeskDeletedUser -UserId

        Returns a specific deleted user by id.
    .EXAMPLE
        PS C:\> Get-ZendeskDeletedUser -Context $context

        Returns deleted users using a connection context from `Get-ZendeskConnection`.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Unique Id of the User to retrieve
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    if ($PSBoundParameters.ContainsKey('UserId')) {
        $path = "/api/v2/deleted_users/$UserId.json"
        $key = 'deleted_user'
    } else {
        $path = '/api/v2/deleted_users.json'
        $key = 'deleted_users'
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand $key

}
