
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'New-UserIdentity' {

    InModuleScope PwshZendesk {

        $IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

        $context = @{
            Organization = 'company'
            BaseUrl      = 'https://company.testdesk.com'
            Credential   = [System.Management.Automation.PSCredential]::New("email", ('api-key' | ConvertTo-SecureString -AsPlainText -Force))
            User         = [PSCustomObject]@{ role = 'admin' }
        }
        $context | Add-Member -TypeName 'ZendeskContext'

        Mock -ModuleName PwshZendesk Invoke-Method { }

        It 'Requires a UserId to be supplied' {
            if ($IsInteractive) {
                throw 'Please run test in non-interactive mode'
            }

            { New-UserIdentity -Type 'email' -Value 'name@company.com' } | Should -Throw
        }

        It 'Requires UserId to be positive' {
            { New-UserIdentity -UserId -1 -Type 'email' -Value 'name@company.com' } | Should -Throw
        }

        It 'Requires UserId to be Int64' {
            { New-UserIdentity -UserId 'a' -Type 'email' -Value 'name@company.com' } | Should -Throw
        }

        It 'Requires a Type to be supplied' {
            if ($IsInteractive) {
                throw 'Please run test in non-interactive mode'
            }

            { New-UserIdentity -UserId -1 -Value 'name@company.com'} | Should -Throw
        }

        It 'Requires Type to be a string' {
            { New-UserIdentity -UserId -1 -Type @{ A = 1 } -Value 'name@company.com'} | Should -Throw
        }

        It 'Accepts Type: <Type>' -TestCases @(
            @{ Type = 'email' }
            @{ Type = 'twitter' }
            @{ Type = 'facebook' }
            @{ Type = 'google' }
            @{ Type = 'phone_number' }
            @{ Type = 'agent_fowarding' }
            @{ Type = 'sdk' }
        ) {
            param ($Type)

            New-UserIdentity -UserId 1 -Type $Type -Value 'value' -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -Scope It
        }

        It 'Create Identity Endpoint' {
            New-UserIdentity -UserId 1 -Type 'email' -Value 'name@company.com' -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '/api/v2/users/\d+/identities.json' -and $Method -eq 'Post' } -Scope It
        }

        It 'Passes on the UserId' {
            New-UserIdentity -UserId 736088406 -Type 'email' -Value 'name@company.com' -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '736088406' } -Scope It
        }

        It 'Explicitly set as Verified' {
            New-UserIdentity -UserId 736088406 -Type 'email' -Value 'name@company.com' -Verified -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Body.identity.verified -eq $true } -Scope It
        }

        It 'Explicitly set as not Verified' {
            New-UserIdentity -UserId 736088406 -Type 'email' -Value 'name@company.com' -Verified:$false -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Body.identity.verified -eq $false } -Scope It
        }

        It 'Implicitly set as not Verified' {
            New-UserIdentity -UserId 736088406 -Type 'email' -Value 'name@company.com' -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Body.identity.verified -eq $false } -Scope It
        }

        It 'Setting as Primary requires also setting as Verified' {
            if ($IsInteractive) {
                throw 'Please run test in non-interactive mode'
            }

            { New-UserIdentity -UserId 736088406 -Type 'email' -Value 'name@company.com' -Primary -Confirm:$false } | Should -Throw
        }

        It 'Explicitly set as Primary' {
            New-UserIdentity -UserId 736088406 -Type 'email' -Value 'name@company.com' -Verified -Primary -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Body.identity.primary -eq $true } -Scope It
        }

        It 'Explicitly set as not Primary' {
            New-UserIdentity -UserId 736088406 -Type 'email' -Value 'name@company.com' -Verified -Primary:$false -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Body.identity.primary -eq $false } -Scope It
        }

        It 'Implicitly set as not Primary' {
            New-UserIdentity -UserId 736088406 -Type 'email' -Value 'name@company.com' -Verified -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Body.identity.primary -eq $false } -Scope It
        }

        It 'Passes on the Context' {
            New-UserIdentity -Context $context -UserId 1 -Type 'email' -Value 'name@company.com' -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $null -ne $Context } -Scope It
        }

        It 'Does nothing in WhatIf' {
            New-UserIdentity -Context $context -UserId 1 -Type 'email' -Value 'name@company.com' -WhatIf
            Assert-MockCalled Invoke-Method -Exactly 0 -Scope It
        }
    }
}
