
function Merge-User {
    <#
    .SYNOPSIS
        Merges two end users together.
    .DESCRIPTION
        Merges two end users together. Agents and Admin cannot be merged.
    .EXAMPLE
        PS C:\> Merge-ZendeskUser -UserId 1 -TargetUserId 2

        Merges end user with id 1 into end user with id 2.
    .EXAMPLE
        PS C:\> Merge-ZendeskUser -Context $context -UserId 1 -TargetUserId 2

        Merges end user with id 1 into end user with id 2 providing a connection context returend by `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique Id of the user to merge
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # Unique Id of the user to merge into
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $TargetUserId,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAdmin -Context $Context

    $path = "/api/v2/users/$UserId/merge.json"
    $body = @{
        user = @{
            id = $TargetUserId
        }
    }

    if ($PSCmdlet.ShouldProcess("$UserId => $TargetUserId", 'Merge user.')) {
        $result = Invoke-Method -Context $Context -Method 'Put' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
