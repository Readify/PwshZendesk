
function Get-Attachment {
    <#
    .SYNOPSIS
        Gets an attachment by id
    .DESCRIPTION
        Gets an attachment by id.
    .EXAMPLE
        PS C:\> Get-ZendeskAttachment -Id 1

        Retrieves the attachment with id 1
    .EXAMPLE
        PS C:\> Get-ZendeskAttachment -Context $context -Id 1

        Retrieves the attachment with id 1 with a connection context returned by `Get-ZendeskConnection`
    .NOTES
        The id is the zendesk id of the attachment record and not the token used to associate the attachment with a comment.
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    Param (
        # Unique Id of the attachment to retrieve
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]
        $Id,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    $path = "/api/v2/attachments/$Id.json"

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result

}
