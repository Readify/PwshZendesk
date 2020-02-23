
function Get-JobStatus {
    <#
    .SYNOPSIS
        Shows the current statuses for background jobs running.
    .DESCRIPTION
        Shows the current statuses for background jobs running.
    .EXAMPLE
        PS C:\> Get-ZendeskJobStatus

        Shows the current statuses for background jobs running.
    .EXAMPLE
        PS C:\> Get-ZendeskJobStatus -Id 1

        Shows the status of the background job with id 1.
    .EXAMPLE
        PS C:\> Get-ZendeskJobStatus -Context $context

        Shows the current statuses for background jobs running with connection context from `Get-ZendeskConnection`.
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    Param (
        # Unique Id of the background job whose status to retrieve
        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64[]]
        $Id,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    Assert-IsAgent -Context $Context

    $key = 'job_statuses'

    if ($PSBoundParameters.ContainsKey('Id')) {

        if ($Id.count -gt 1) {
            $ids = $Id -join ','
            $path = "/api/v2/job_statuses/show_many.json?ids=$ids"
        } else {
            $path = "/api/v2/job_statuses/$Id.json"
            $key = 'job_status'
        }

    } else {
        $path = '/api/v2/job_statuses.json'
    }

    $result = Invoke-Method -Context $Context -Path $path -Verbose:$VerbosePreference
    $result | Select-Object -Expand $key

}
