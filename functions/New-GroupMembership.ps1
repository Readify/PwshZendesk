
function New-GroupMembership {

    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true)]
    Param (

        # The id of an agent
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # The id of a group
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $GroupId,

        # If true, tickets assigned directly to the agent will assume this membership's group.
        [Parameter(Mandatory = $false)]
        [Switch]
        $Default,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = 'api/v2/group_memberships.json'
    $body = @{
        group_membership = @{
            user_id  = $UserId
            group_id = $GroupId
            default  = $Default
        }
    }

    if ($PSCmdlet.ShouldProcess($UserId, "Assign to Group: $GroupId")) {
        $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
