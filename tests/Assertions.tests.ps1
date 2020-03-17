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

        Context 'Admin with context' {

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

        Context 'Agent with context' {

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

        Context 'End User with context' {

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

        $Script:Context = $context
        Remove-Variable -Name context

        Context 'Admin while connected' {

            $Script:Context.User.role = 'admin'

            It 'Test-IsAdmin => $true' {
                Test-IsAdmin | Should -Be $true
            }

            It 'Test-IsAgent => $false' {
                Test-IsAgent | Should -Be $false
            }

            It 'Test-IsEndUser => $false' {
                Test-IsEndUser | Should -Be $false
            }

            It 'Assert-IsAdmin passes' {
                { Assert-IsAdmin } | Should -Not -Throw
            }

            It 'Assert-IsAgent passes' {
                { Assert-IsAgent } | Should -Not -Throw
            }

            It 'Assert-IsEndUser throws' {
                { Assert-IsEndUser } | Should -Throw
            }

        }

        Context 'Agent while connected' {

            $Script:Context.User.role = 'agent'

            It 'Test-IsAdmin => $false' {
                Test-IsAdmin | Should -Be $false
            }

            It 'Test-IsAgent => $true' {
                Test-IsAgent | Should -Be $true
            }

            It 'Test-IsEndUser => $false' {
                Test-IsEndUser | Should -Be $false
            }

            It 'Assert-IsAdmin throw' {
                { Assert-IsAdmin } | Should -Throw
            }

            It 'Assert-IsAgent passes' {
                { Assert-IsAgent } | Should -Not -Throw
            }

            It 'Assert-IsEndUser throws' {
                { Assert-IsEndUser } | Should -Throw
            }

        }

        Context 'End User while connected' {

            $Script:Context.User.role = 'end-user'

            It 'Test-IsAdmin => $false' {
                Test-IsAdmin | Should -Be $false
            }

            It 'Test-IsAgent => $false' {
                Test-IsAgent | Should -Be $false
            }

            It 'Test-IsEndUser => $true' {
                Test-IsEndUser | Should -Be $true
            }

            It 'Assert-IsAdmin throws' {
                { Assert-IsAdmin } | Should -Throw
            }

            It 'Assert-IsAgent throws' {
                { Assert-IsAgent } | Should -Throw
            }

            It 'Assert-IsEndUser passes' {
                { Assert-IsEndUser } | Should -Not -Throw
            }

        }

        Context 'Not connected' {

            Remove-Variable -Name Context -Scope Script

            It 'Assert-IsAdmin throws' {
                { Assert-IsAdmin } | Should -Throw 'No connection supplied'
            }

            It 'Assert-IsAgent throws' {
                { Assert-IsAgent } | Should -Throw 'No connection supplied'
            }

            It 'Assert-IsEndUser throws' {
                { Assert-IsEndUser } | Should -Throw 'No connection supplied'
            }
        }

    }

}
