
function Remove-Attachment {
    <#
    .SYNOPSIS
        Deletes an attachment that has not been attached to a comment.
    .DESCRIPTION
        Deletes an attachment that has not been attached to a comment.
    .EXAMPLE
        PS C:\> Remove-ZendeskAttachment -Token '6bk3gql82em5nmf'

        Deletes the unused attachment with token '6bk3gql82em5nmf'
    .EXAMPLE
        PS C:\> Remove-ZendeskAttachment -Context $context -Token '6bk3gql82em5nmf'

        Deletes the unused attachment with token '6bk3gql82em5nmf' using a connection context returned by `Get-ZendeskConnection`
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param (
        # Unique token of the attachment to delete
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Token,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/api/v2/uploads/$Token.json"

    if ($PSCmdlet.ShouldProcess($Token, 'Delete attachment')) {
        $result = Invoke-Method -Context $Context -Method 'Delete' -Path $path -Verbose:$VerbosePreference
        $result
    }

}
