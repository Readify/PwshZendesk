
function Invoke-Method {
    <#
    .SYNOPSIS
        Makes a call to a Zendesk Api Endpoint
    .DESCRIPTION
        Makes a call to a Zendesk Api Endpoint
    .EXAMPLE
        PS C:\> Invoke-Method -path '/api/v2/tickets.json'

        Calls the List Tickets endpoint
    .EXAMPLE
        PS C:\> Invoke-Method -Method 'Post' -path '/api/v2/tickets.json' -Body $ticket

        Calls the Create Ticket endpoint. `$ticket` is a hashtable or PSCustomObject that is automatically converted to json.
    .EXAMPLE
        PS C:\> Invoke-Method -path '/api/v2/tickets.json' -Pagination $false

        Calls the List Tickets endpoint without pagination.
    .EXAMPLE
        PS C:\> Invoke-Method -path '/api/v2/tickets.json' -SortBy 'id'

        Calls the List Tickets endpoint sorted by id.
    .EXAMPLE
        PS C:\> Invoke-Method -path '/api/v2/tickets.json' -SortBy $null

        Calls the List Tickets endpoint without explicit sorting.
    .EXAMPLE
        PS C:\> Invoke-Method -path '/api/v2/tickets.json' -Retry $false

        Calls the List Tickets endpoint without rety.
    .EXAMPLE
        PS C:\> Invoke-Method -path '/api/v2/tickets.json' -SideLoad 'user'

        Calls the List Tickets endpoint with user sideloading.
    .NOTES
        Method defaults to 'Get'

        Paths begin with '/api' as listed in the Zendesk API doco.

        ContentType defaults to 'application/json'

        If the ContentType is not overriden then the Body is automatically converted to Json.

        Pagination is done by default

        Sortby defaults to 'created_at'. Set to $null to follows the endpoints default sorting.

        Exponential retries api limited calls by default.
    #>
    [OutputType([PSCustomObject])]
    [CMDletBinding()]
    Param (
        # Rest Method
        [Parameter(Mandatory = $false)]
        [ValidateSet('Delete', 'Get', 'Post', 'Put')]
        [String]
        $Method = 'Get',

        # Path of the rest request. eg `/Account`
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Path,

        # Body of the Rest call
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $Body,

        # Content-Type of the body content
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentType = 'application/json',

        # Whether to perform pagination.
        [Parameter(Mandatory = $false)]
        [Boolean]
        $Pagination = $true,

        # Property to sort by. Set to `$null` for no sorting. Defaults to `created_at`
        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [String]
        $SortBy = 'created_at',

        # Whether to retry when rate limited.
        [Parameter(Mandatory = $false)]
        [Boolean]
        $Retry = $true,

        # Entities to sideload in the request
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(
            'abilities',
            'app_installation',
            'brands',
            'categories',
            'comment_count',
            'comment_events',
            'dates',
            'groups',
            'identities',
            'incident_counts',
            'last_audits',
            'metric_events',
            'metric_sets',
            'open_ticket_count',
            'organizations',
            'permissions',
            'roles',
            'sharing_agreements',
            'slas',
            'ticket_forms',
            'tickets',
            'usage_1h',
            'usage_24h',
            'usage_30d',
            'usage_7d',
            'users'
        )]
        [String[]]
        $SideLoad,

        # Zendesk Connection Context from `Get-ZendeskConnection`
        [Parameter(Mandatory = $false)]
        [PSTypeName('ZendeskContext')]
        [PSCustomObject]
        $Context = $null
    )

    # Determine the context
    if ($null -eq $Context) {
        if (Test-Path Variable:\Script:Context) {
            $Context = $Script:Context
        } else {
            throw $Script:NotConnectedMessage
        }
    }

    $params = @{
        Method      = $Method
        ContentType = 'application/json; charset=utf-8'
        Headers     = @{
            Accept = 'application/json; charset=utf-8'
        }
    }

    if ($PSVersionTable.PSEdition -eq 'Core') {
        # PS Core added native Basic Auth support
        $params.Credential = $Context.Credential
        $params.Authentication = 'Basic'
    } else {
        # PS Desktop requires manual header creation. Basic auth is only supported by challenge.
        $raw = '{0}:{1}' -f $Context.Credential.GetNetworkCredential().username, $Context.Credential.GetNetworkCredential().password
        $bytes = [System.Text.Encoding]::ASCII.GetBytes($raw)
        $encoded = [Convert]::ToBase64String($bytes)

        $params.Headers.Authorization = "Basic $encoded"
    }

    if ($PSBoundParameters.ContainsKey('Body')) {
        if ($ContentType -eq 'application/json') {
            if ($PSVersionTable.PSVersion -ge '6.2.0') {
                $params.Body = $Body | ConvertTo-Json -Depth 5 -Compress -EscapeHandling EscapeNonAscii
            } else {
                $params.Body = $Body | ConvertTo-Json -Depth 5 -Compress | ConvertTo-UnicodeEscape
            }
        } else {
            $params.Body = $Body
        }
        $params.ContentType = $ContentType

        $params.Body | Out-String | Write-Debug
    }

    $uri = $Context.BaseUrl + $Path

    while (-not [String]::IsNullOrEmpty($uri)) {
        Write-Debug -Message "Uri before SortBy: $uri"
        if (-not [String]::IsNullOrEmpty($SortBy) -and $uri -notmatch 'sort_by=') {
            if ($uri -match '\?') {
                $uri += "&sort_by=$SortBy"
            } else {
                $uri += "?sort_by=$SortBy"
            }
        }

        Write-Debug -Message "Uri before Sideload: $uri"
        if (-not [String]::IsNullOrEmpty($SideLoad) -and $uri -notmatch 'include=') {
            $sideloadJoined = $SideLoad -join ','
            if ($uri -match '\?') {
                $uri += "&include=$sideloadJoined"
            } else {
                $uri += "?include=$sideloadJoined"
            }
        }

        try {
            $result = Invoke-RestMethod @params -Uri $uri -Verbose:$VerbosePreference
            $result
        } catch {
            $errorRecord = $_
        }

        # 429 Too Many Requests - Exponential rety with jitter.
        $multiplier = 1
        while ($Retry -and (Test-Path -Path Variable:/errorRecord) -and $null -ne $errorRecord -and
            $errorRecord.Exception.GetType().Name -in @('HttpResponseException', 'WebException') -and
            $errorRecord.Exception.Response.StatusCode.value__ -eq 429) {

            if ($PSVersionTable.PSEdition -eq 'Core') {
                $retryAfter = $errorRecord.Exception.Response.Headers.RetryAfter.Delta.TotalSeconds
            } else {
                $retryAfter = $errorRecord.Exception.Response.Headers['Retry-After']
            }
            $retryAfter = 1

            $multiplier *= 2
            $jitter = Get-Random -Minimum 0.0 -Maximum 1.0

            $sleep = $retryAfter + $multiplier + $jitter
            Write-Warning -Message "Too many requests! Retrying after $sleep seconds."
            Start-Sleep -Seconds $sleep

            $errorRecord = $null
            try {
                $result = Invoke-RestMethod @params -Uri $uri -Verbose:$VerbosePreference
                $result
            } catch {
                $errorRecord = $_
            }
        }

        if ((Test-Path -Path Variable:\errorRecord) -and $null -ne $errorRecord) {
            # Get just the message without stack trace, category info, or qualified error
            $errorMessage = $errorRecord.ToString()
            Get-PSCallStack | ForEach-Object { $errorMessage += "`n" + $_.Command + ': line ' + $_.ScriptLineNumber }
            throw $errorMessage
        }

        $uri = $null
        if ($Pagination) {
            if ($null -ne $result -and (Get-Member -InputObject $result -Name 'next_page' -MemberType Properties)) {
                $uri = $result.next_page
            }
        }
    }
}
