
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'Update-UserIdentity' {

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

            { Update-UserIdentity -Context $context -Id 2 -Value 'name@company.com' } | Should -Throw
        }

        It 'Requires UserId to be positive' {
            { Update-UserIdentity -Context $context -UserId -1 -Id 2 -Value 'name@company.com' } | Should -Throw
        }

        It 'Requires UserId to be Int64' {
            { Update-UserIdentity -Context $context -UserId 'a' -Id 2 -Value 'name@company.com' } | Should -Throw
        }

        It 'Requires a Id to be supplied' {
            if ($IsInteractive) {
                throw 'Please run test in non-interactive mode'
            }

            { Update-UserIdentity -Context $context -UserId 1 -Value 'name@company.com' } | Should -Throw
        }

        It 'Requires Id to be positive' {
            { Update-UserIdentity -Context $context -UserId 1 -Id -1 -Value 'name@company.com' } | Should -Throw
        }

        It 'Requires Id to be Int64' {
            { Update-UserIdentity -Context $context -UserId 1 -Id 'a' -Value 'name@company.com' } | Should -Throw
        }

        It 'Passes on the UserId' {
            Update-UserIdentity -Context $context -UserId 736088406 -Id 1 -Value 'name@company.com' -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '736088406' } -Scope It
        }

        It 'Passes on the Id' {
            Update-UserIdentity -Context $context -Id 736088406 -UserId 1 -Value 'name@company.com' -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '736088406' } -Scope It
        }

        It 'Explicitly set as Verified' {
            Update-UserIdentity -Context $context -UserId 736088406 -Id 1 -Value 'name@company.com' -Verified -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Body.identity.verified -eq $true } -Scope It
        }

        It 'Passes on the Context' {
            Update-UserIdentity -Context $context -UserId 1 -Id 1 -Value 'name@company.com' -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $null -ne $Context } -Scope It
        }

        It 'Does nothing in WhatIf' {
            Update-UserIdentity -Context $context -UserId 1 -Id 1 -WhatIf
            Assert-MockCalled Invoke-Method -Exactly 0 -Scope It
        }
    }
}
