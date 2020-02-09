
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'Get-UserIdentity' {

    InModuleScope PwshZendesk {

        $IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

        $context = @{
            Organization = 'company'
            BaseUrl      = 'https://company.testdesk.com'
            Credential   = [System.Management.Automation.PSCredential]::New("email", ('api-key' | ConvertTo-SecureString -AsPlainText -Force))
        }
        $context | Add-Member -TypeName 'ZendeskContext'

        Mock -ModuleName PwshZendesk Invoke-Method { }

        It 'Id is optional' {
            { Get-UserIdentity -UserId 1 } | Should -Not -Throw
        }

        It 'Requires Id to be positive' {
            { Get-UserIdentity -UserId 1 -Id -1 } | Should -Throw
        }

        It 'Requires Id to be Int64' {
            { Get-UserIdentity -UserId 1 -Id 'a' } | Should -Throw
        }

        It 'Requires a UserId to be supplied' {
            if ($IsInteractive) {
                throw 'Please run test in non-interactive mode'
            }

            { Get-UserIdentity -Id 1 } | Should -Throw
        }

        It 'Requires UserId to be positive' {
            { Get-UserIdentity -UserId -1 -Id 1 } | Should -Throw
        }

        It 'Requires UserId to be Int64' {
            { Get-UserIdentity -UserId 'a' -Id 1 } | Should -Throw
        }

        It 'List Identities Endpoint' {
            Get-UserIdentity -UserId 1
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '/api/v2/users/\d+/identities.json' -and ($null -eq $Method -or $Method -eq 'Get') } -Scope It
        }

        It 'Show Identity Endpoint' {
            Get-UserIdentity -UserId 1 -Id 1
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '/api/v2/users/\d+/identities/\d+.json' -and ($null -eq $Method -or $Method -eq 'Get') } -Scope It
        }

        It 'Passes on the UserId List' {
            Get-UserIdentity -UserId 736088406
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '736088406' } -Scope It
        }

        It 'Passes on the UserId Show' {
            Get-UserIdentity -UserId 736088406 -Id 1
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '736088406' } -Scope It
        }

        It 'Passes on the Id' {
            Get-UserIdentity -UserId 1 -Id 736088406
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $Path -match '736088406' } -Scope It
        }

        It 'Passes on the Context' {
            Get-UserIdentity -Context $context -UserId 1 -Id 1
            Assert-MockCalled Invoke-Method -Exactly 1 -ParameterFilter { $null -ne $Context } -Scope It
        }
    }
}
