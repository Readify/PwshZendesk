
function New-GroupMembership {
    <#
    .SYNOPSIS
        Assigns an agent to a given group.
    .DESCRIPTION
        Assigns an agent to a given group.
    .EXAMPLE
        PS C:\> New-ZendeskGroupMembership -UserId 1 -GroupId 2

        Assigns the agent with id 1 to the group with id 2
    .EXAMPLE
        PS C:\> New-ZendeskGroupMembership -UserId 1 -GroupId 2 -Default

        Assigns the agent with id 1 to the group with id 2 and makes that group their default group.
    .EXAMPLE
        PS C:\> New-ZendeskGroupMembership -Membership @{ UserId = 1; GroupId = 2 }

        Assigns the agent with id 1 to the group with id 2
    .EXAMPLE
        PS C:\> New-ZendeskGroupMembership -Membership @( @{ UserId = 1; GroupId = 2 }, @{ UserId = 1; GroupId = 3 } )

        Assigns the agent with id 1 to the groups with ids 2 and 3
    .EXAMPLE
        PS C:\> New-ZendeskGroupMembership -Context $context -UserId 1 -GroupId 2

        Assigns the agent with id 1 to the group with id 2 using a connection context from `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (

        # The id of an agent
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Properties')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $UserId,

        # The id of a group
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Properties')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $GroupId,

        # If true, tickets assigned directly to the agent will assume this membership's group.
        [Parameter(Mandatory = $false,
            ParameterSetName = 'Properties')]
        [Switch]
        $Default,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Object')]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject[]]
        $Membership,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAdmin -Context $Context

    if ($PSCmdlet.ParameterSetName -eq 'Properties') {
        $path = "/api/v2/users/$UserId/group_memberships.json"
        $body = @{
            group_membership = @{
                user_id  = $UserId
                group_id = $GroupId
                default  = $Default
            }
        }
    } else {
        if ($Membership.Count -gt 1) {
            $path = '/api/v2/group_memberships/create_many.json'
            $body = @{
                group_memberships = $Membership
            }
        } else {
            $path = '/api/v2/group_memberships.json'
            $body = @{
                group_membership = $Membership
            }
        }
    }

    if ($PSCmdlet.ShouldProcess($UserId, "Assign to Group: $GroupId")) {
        $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
