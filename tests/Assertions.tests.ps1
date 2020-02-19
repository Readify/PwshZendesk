[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'Users Routes' {

    InModuleScope PwshZendesk {

        $context = @{
            Organization = 'company'
            BaseUrl      = 'https://company.testdesk.com'
            Credential   = [System.Management.Automation.PSCredential]::New('email', ('api-key' | ConvertTo-SecureString -AsPlainText -Force))
            User         = [PSCustomObject]@{ role = '' }
        }
        $context | Add-Member -TypeName 'ZendeskContext'

        Context 'Admin' {

            $context.User.role = 'admin'

            It 'Test-IsAdmin => $true' {
                Test-IsAdmin -Context $context | Should -Be $true
            }

            It 'Test-IsAgent => $false' {
                Test-IsAgent -Context $context | Should -Be $false
            }

            It 'Test-IsEndUser => $false' {
                Test-IsEndUser -Context $context | Should -Be $false
            }

            It 'Assert-IsAdmin passes' {
                { Assert-IsAdmin -Context $context } | Should -Not -Throw
            }

            It 'Assert-IsAgent passes' {
                { Assert-IsAgent -Context $context } | Should -Not -Throw
            }

            It 'Assert-IsEndUser throws' {
                { Assert-IsEndUser -Context $context } | Should -Throw
            }

        }

        Context 'Agent' {

            $context.User.role = 'agent'

            It 'Test-IsAdmin => $false' {
                Test-IsAdmin -Context $context | Should -Be $false
            }

            It 'Test-IsAgent => $true' {
                Test-IsAgent -Context $context | Should -Be $true
            }

            It 'Test-IsEndUser => $false' {
                Test-IsEndUser -Context $context | Should -Be $false
            }

            It 'Assert-IsAdmin throw' {
                { Assert-IsAdmin -Context $context } | Should -Throw
            }

            It 'Assert-IsAgent passes' {
                { Assert-IsAgent -Context $context } | Should -Not -Throw
            }

            It 'Assert-IsEndUser throws' {
                { Assert-IsEndUser -Context $context } | Should -Throw
            }

        }

        Context 'End User' {

            $context.User.role = 'end-user'

            It 'Test-IsAdmin => $false' {
                Test-IsAdmin -Context $context | Should -Be $false
            }

            It 'Test-IsAgent => $false' {
                Test-IsAgent -Context $context | Should -Be $false
            }

            It 'Test-IsEndUser => $true' {
                Test-IsEndUser -Context $context | Should -Be $true
            }

            It 'Assert-IsAdmin throws' {
                { Assert-IsAdmin -Context $context } | Should -Throw
            }

            It 'Assert-IsAgent throws' {
                { Assert-IsAgent -Context $context } | Should -Throw
            }

            It 'Assert-IsEndUser passes' {
                { Assert-IsEndUser -Context $context } | Should -Not -Throw
            }

        }

    }

}
