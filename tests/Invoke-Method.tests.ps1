[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'Invoke-Method' -Tags 'internet' {

    InModuleScope PwshZendesk {

        $IRM = Get-Command -Name 'Invoke-RestMethod' -Module 'Microsoft.PowerShell.Utility'

        $context = @{
            Organization = 'company'
            BaseUrl      = 'https://company.testdesk.com'
            Credential   = [System.Management.Automation.PSCredential]::New("email", ('api-key' | ConvertTo-SecureString -AsPlainText -Force))
        }
        $context | Add-Member -TypeName 'ZendeskContext'

        Mock -ModuleName PwshZendesk Invoke-RestMethod { }

        It 'Uses the baseUrl' {
            Invoke-Method -Context $context -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -match 'https://company.testdesk.com' } -Scope It
        }

        It 'Uses the path' {
            Invoke-Method -Context $context -Path '/Thing'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -match '/Thing' } -Scope It
        }

        It 'Accepts JSON' {
            Invoke-Method -Context $context -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                $Headers.ContainsKey('Accept') -and $Headers.Accept -match 'application\/json'
            } -Scope It
        }

        It 'Cascades Verbose' {
            Invoke-Method -Context $context -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { -not $VerbosePreference } -Scope It

            Invoke-Method -Context $context -Path '/' -Verbose
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $VerbosePreference } -Scope It

            Invoke-Method -Context $context -Path '/' -Verbose:$false
            Assert-MockCalled Invoke-RestMethod -Exactly 2 -ParameterFilter { -not $VerbosePreference } -Scope It
        }

        It 'Default Method: Get' {
            Invoke-Method -Context $context -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' } -Scope It
        }

        It 'Explicit Method: Get' {
            Invoke-Method -Context $context -Method 'Get' -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' } -Scope It
        }

        It 'Explicit Method: Post' {
            Invoke-Method -Context $context -Method 'Post' -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' } -Scope It
        }

        It 'Explicit Method: Put' {
            Invoke-Method -Context $context -Method 'Put' -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' } -Scope It
        }

        It 'Explicit Method: Delete' {
            Invoke-Method -Context $context -Method 'Delete' -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' } -Scope It
        }

        It 'Throws with no connection' {
            { Invoke-Method -Path '/' } | Should -Throw
        }

        It 'Throws with no invalid connection type' {
            $block = {
                Invoke-Method -Path '/' -Context [PSCustomObject]@{
                    Organization = 'company'
                    BaseUrl = 'https://company.testdesk.com'
                    Credential = $null
                }
            }
            $block | Should -Throw
        }

        It 'Converts Body to JSON by default' {
            Invoke-Method -Context $context -Method 'Post' -Path '/' -Body ([PSCustomObject]@{ A = 1; B = 2; C = 3 })
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Body -eq '{"A":1,"B":2,"C":3}' } -Scope It
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $ContentType -eq 'application/json' } -Scope It
        }

        It 'Leaves Body alone with explicit ContentType' {
            Invoke-Method -Context $context -Method 'Post' -Path '/' -Body 'The Body' -ContentType 'text/plain'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Body -eq 'The Body' } -Scope It
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $ContentType -eq 'text/plain' } -Scope It
        }

        It 'Sorts by created_at by default' {
            Invoke-Method -Context $context -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -match 'sort_by=created_at' } -Scope It
        }

        It 'Sorts by any supplied property' {
            Invoke-Method -Context $context -Path '/' -SortBy 'name'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -match 'sort_by=name' } -Scope It
        }

        It 'Doesn;t sort when SortBy is set to $null' {
            Invoke-Method -Context $context -Path '/' -SortBy $null
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -notmatch 'sort_by' } -Scope It
        }

        It 'Can sort if path includes query variables' {
            Invoke-Method -Context $context -Path '/thing?name=jim'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -match '\?name=jim&sort_by' } -Scope It
        }

        Mock -ModuleName PwshZendesk Invoke-RestMethod { & $IRM 'httpstat.us/404' }

        It 'Throws on a 404' {
            { Invoke-Method -Context $context -Path '/' } | Should -Throw
        }

        It 'Passes on 404 error message' {
            try { Invoke-Method -Context $context -Path '/' } catch { $E = $_ }
            $E | Should -Match '\(?404\)? \(?Not Found\)?'
        }

        Mock -ModuleName PwshZendesk Invoke-RestMethod { & $IRM 'httpstat.us/400' }

        It 'Passes on 400 error message' {
            try { Invoke-Method -Context $context -Path '/' } catch { $E = $_ }
            $E | Should -Match '\(?400\)? \(?Bad Request\)?'
        }

        Mock -ModuleName PwshZendesk Invoke-RestMethod { & $IRM 'httpstat.us/500' }

        It 'Passes on 500 error message' {
            try { Invoke-Method -Context $context -Path '/' } catch { $E = $_ }
            $E | Should -Match '\(?500\)? \(?Internal Server Error\)?'
        }

        It 'Passes on Calling function' {
            try { Invoke-Method -Context $context -Path '/' } catch { $E = $_ }
            $E | Should -Match '<ScriptBlock>: line 1\d\d'
        }

        Mock -ModuleName PwshZendesk Invoke-RestMethod {
            if ($Uri -match 'idx=([0-9])') {
                $idx = [int]$Matches[1]
                if ($idx -eq 5) {
                    [PSCustomObject]@{
                        next_page = $null
                    }
                } else {
                    $idx += 1
                    [PSCustomObject]@{
                        next_page = $Uri -replace 'idx=[0-9]', "idx=$idx"
                    }
                }
            } else {
                throw 'no idx'
            }
        }

        It 'Pages by default' {
            Invoke-Method -Context $context -Path '/Thing?idx=1'
            Assert-MockCalled Invoke-RestMethod -Exactly 5 -Scope It
        }

        It 'Pages explicitly' {
            Invoke-Method -Context $context -Path '/Thing?idx=1' -Pagination $true
            Assert-MockCalled Invoke-RestMethod -Exactly 5 -Scope It
        }

        It 'Does not page when asked not to' {
            Invoke-Method -Context $context -Path '/Thing?idx=1' -Pagination $false
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -Scope It
        }

        $Script:attempts = 0
        Mock -ModuleName PwshZendesk Invoke-RestMethod {
            $Script:attempts += 1
            if ($Script:attempts -lt 3) {
                & $IRM 'httpstat.us/429'
            }
        }

        It 'Does not rety if requested not to' {
            $Script:attempts = 0
            { Invoke-Method -Context $context -Path '/' -Retry $false } | Should -Throw
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -Scope It
        }

        It 'Retries by default' {
            $Script:attempts = 0
            Invoke-Method -Context $context -Path '/' 3>$null
            Assert-MockCalled Invoke-RestMethod -Exactly 3 -Scope It
        }

        It 'Retries explicitly' {
            $Script:attempts = 0
            Invoke-Method -Context $context -Path '/' -Retry $true 3>$null
            Assert-MockCalled Invoke-RestMethod -Exactly 3 -Scope It
        }

        Mock -ModuleName PwshZendesk Invoke-RestMethod { }
        $Script:Context = $context

        It 'Uses the stored context' {
            Invoke-Method -Path '/'
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -Scope It
        }
    }
}
