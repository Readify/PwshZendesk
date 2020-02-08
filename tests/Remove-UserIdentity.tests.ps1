
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'Remove-UserIdentity' {

    InModuleScope PwshZendesk {

        $IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

        $context = @{
            Organization = 'company'
            BaseUrl      = 'https://company.testdesk.com'
            Credential   = [System.Management.Automation.PSCredential]::New("email", ('api-key' | ConvertTo-SecureString -AsPlainText -Force))
        }
        $context | Add-Member -TypeName 'ZendeskContext'

        Mock -ModuleName PwshZendesk Invoke-Method { }

        It 'Requires an Id to be supplied' {
            if ($IsInteractive) {
                throw 'Please run test in non-interactive mode'
            }

            { Remove-UserIdentity -UserId 1 } | Should -Throw
        }

        It 'Requires Id to be positive' {
            { Remove-UserIdentity -UserId 1 -Id -1 } | Should -Throw
        }

        It 'Requires Id to be Int64' {
            { Remove-UserIdentity -UserId 1 -Id 'a' } | Should -Throw
        }

        It 'Requires a UserId to be supplied' {
            if ($IsInteractive) {
                throw 'Please run test in non-interactive mode'
            }

            { Remove-UserIdentity -Id 1 } | Should -Throw
        }

        It 'Requires UserId to be positive' {
            { Remove-UserIdentity -UserId -1 -Id 1 } | Should -Throw
        }

        It 'Requires UserId to be Int64' {
            { Remove-UserIdentity -UserId 'a' -Id 1 } | Should -Throw
        }

        It 'Hits the correct endpoint' {
            Remove-UserIdentity -UserId 1 -Id 1 -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '/api/v2/users/\d+/identities/\d+.json' -and $Method -eq 'Delete' } -Scope It
        }

        It 'Passes on the UserId' {
            Remove-UserIdentity -UserId 736088406 -Id 1 -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '736088406' } -Scope It
        }

        It 'Passes on the Id' {
            Remove-UserIdentity -UserId 1 -Id 736088406 -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '736088406' } -Scope It
        }

        It 'Passes on the Context' {
            Remove-UserIdentity -Context $context -UserId 1 -Id 1 -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $null -ne $Context } -Scope It
        }

        It 'Does nothing in WhatIf' {
            Remove-UserIdentity -UserId 1 -Id 1 -WhatIf
            Assert-MockCalled Invoke-Method -Exactly 0 -Scope It
        }
    }
}
