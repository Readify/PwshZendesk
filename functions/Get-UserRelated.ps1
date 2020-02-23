
function Get-UserRelated {
    <#
    .SYNOPSIS
        Returns counts of tickets and organizations related to the given user.
    .DESCRIPTION
        Returns counts of assigned tickets, requested tickets, cc'd tickets, and organizations related to the given user.
    .EXAMPLE
        PS C:\> Get-ZendeskUserRelated -UserId 1

        Gets counts of tickets and organizations related to user with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskUserRelated -Context $context -UserId 1

        Gets counts of tickets and organizations related to user with id 1 using a connection context returned by `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Unique Id of the user to get related information for
        [Parameter(Mandatory = $true)]
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

    $result = Invoke-Method -Path "/api/v2/users/$UserId/related.json" -Context $Context -Verbose:$VerbosePreference
    $result

}
