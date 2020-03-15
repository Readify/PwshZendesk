
function New-SharingAgreement {
    <#
    .SYNOPSIS
        Creates a sharing agreement.
    .DESCRIPTION
        Creatas a sharing agreement. Requires sharing to be enabled on the Zendesk instance. For more information see: https://support.zendesk.com/hc/en-us/articles/203661466-Sharing-tickets-with-other-Zendesk-Support-accounts
    .EXAMPLE
        PS C:\> New-ZendeskSharingAgreement -RemoteSubdomain 'Foo'

        Creates a new sharing agreement with the Foo Zendesk Support instance.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Name of this sharing agreement
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        # The direction of the agreement
        [Parameter(Mandatory = $false)]
        [ValidateSet('inbound', 'outbound')]
        [String]
        $Type,

        # The status of the agreement
        [Parameter(Mandatory = $false)]
        [ValidateSet('accepted', 'declined', 'pending', 'inactive')]
        [String]
        $Status,

        # The Partner System
        [Parameter(Mandatory = $false)]
        [ValidateSet('jira')]
        [String]
        $PartnerName,

        # Subdomain of the remote account
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $RemoteSubdomain,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAdmin -Context $Context

    $path = '/api/v2/sharing_agreements.json'
    $body = @{
        sharing_agreement = @{
        }
    }

    if ($PSBoundParameters.ContainsKey('Name')) {
        $body.sharing_agreement['name'] = $Name
    }

    if ($PSBoundParameters.ContainsKey('Type')) {
        $body.sharing_agreement['type'] = $Type
    }

    if ($PSBoundParameters.ContainsKey('Status')) {
        $body.sharing_agreement['status'] = $Status
    }

    if ($PSBoundParameters.ContainsKey('PartnerName')) {
        $body.sharing_agreement['partner_name'] = $PartnerName
    }

    if ($PSBoundParameters.ContainsKey('RemoteSubdomain')) {
        $body.sharing_agreement['remote_subdomain'] = $RemoteSubdomain
    }

    if ($PSCmdlet.ShouldProcess($Name, 'Create Group')) {
        $result = Invoke-Method -Context $Context -Method 'Post' -Path $path -Body $body -Verbose:$VerbosePreference
        $result
    }

}
