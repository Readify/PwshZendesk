
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'Set-UserIdentityAsVerified' {

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

        It 'Requires an Id to be supplied' {
            if ($IsInteractive) {
                throw 'Please run test in non-interactive mode'
            }

            { Set-UserIdentityAsVerified -Context $context -UserId 1 } | Should -Throw
        }

        It 'Requires Id to be positive' {
            { Set-UserIdentityAsVerified -Context $context -UserId 1 -Id -1 } | Should -Throw
        }

        It 'Requires Id to be Int64' {
            { Set-UserIdentityAsVerified -Context $context -UserId 1 -Id 'a' } | Should -Throw
        }

        It 'Requires a UserId to be supplied' {
            if ($IsInteractive) {
                throw 'Please run test in non-interactive mode'
            }

            { Set-UserIdentityAsVerified -Context $context -Id 1 } | Should -Throw
        }

        It 'Requires UserId to be positive' {
            { Set-UserIdentityAsVerified -Context $context -UserId -1 -Id 1 } | Should -Throw
        }

        It 'Requires UserId to be Int64' {
            { Set-UserIdentityAsVerified -Context $context -UserId 'a' -Id 1 } | Should -Throw
        }

        It 'Passes on the UserId' {
            Set-UserIdentityAsVerified -Context $context -UserId 736088406 -Id 1 -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '736088406' } -Scope It
        }

        It 'Passes on the Id' {
            Set-UserIdentityAsVerified -Context $context -UserId 1 -Id 736088406 -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '736088406' } -Scope It
        }

        It 'Passes on the Context' {
            Set-UserIdentityAsVerified -Context $context -UserId 1 -Id 1 -Confirm:$false
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $null -ne $Context } -Scope It
        }

        It 'Does nothing in WhatIf' {
            Set-UserIdentityAsVerified -Context $context -UserId 1 -Id 1 -WhatIf
            Assert-MockCalled Invoke-Method -Exactly 0 -Scope It
        }
    }
}
