
function Invoke-Method {

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
        Method  = $Method
        Headers = @{
            Accept = 'application/json'
        }
    }

    if ($PSVersionTable.PSEdition -eq 'Core') {
        # PS Core added native Basic Auth support
        $params.Credential = $Context.Credential
        $params.Authentication = 'Basic'
    } else {
        # PS Desktop requires manual header creation. Basic auth is only supported by challenge.
        $raw = '{0}/token:{1}' -f $Context.Credential.username, $Context.Credential.GetNetworkCredential().password
        $bytes = [System.Text.Encoding]::Unicode.GetBytes($raw)
        $encoded =[Convert]::ToBase64String($bytes)

        $params.Headers.Authentication = "basic: $encoded"
    }

    if ($PSBoundParameters.ContainsKey('Body')) {
        if ($ContentType -eq 'application/json') {
            $params.Body = $Body | ConvertTo-Json -Compress
        } else {
            $params.Body = $Body
        }
        $params.ContentType = $ContentType
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
            $errorRecord.Exception -is [Microsoft.PowerShell.Commands.HttpResponseException] -and
            $errorRecord.Exception.Response.StatusCode.value__ -eq 429) {

            $retryAfter = $errorRecord.Exception.Response.Headers.RetryAfter.Delta.TotalSeconds
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
            Get-PSCallStack | Foreach-Object { $errorMessage += "`n" + $_.Command + ': line ' + $_.ScriptLineNumber }
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
