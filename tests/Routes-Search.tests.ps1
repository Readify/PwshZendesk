[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'Search Routes' {

    InModuleScope PwshZendesk {

        $IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

        $context = @{
            Organization = 'company'
            BaseUrl      = 'https://company.testdesk.com'
            Credential   = [System.Management.Automation.PSCredential]::New('email', ('api-key' | ConvertTo-SecureString -AsPlainText -Force))
            User         = [PSCustomObject]@{ role = '' }
        }
        $context | Add-Member -TypeName 'ZendeskContext'

        Mock -ModuleName PwshZendesk Invoke-RestMethod { [PSCustomObject]@{ results = $null; count = 0 } }

        Context 'List Search Results' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'agent'

                { Search- -Context $context -Query 'type:ticket' } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/search\.json\?query=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Search- -Context $context -Query 'type:ticket' } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Search- -Context $context -Query 'type:ticket' } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Search- -Context $context -Query 'type:ticket' } | Should -Not -Throw
            }

        }

        Context 'Show Results Count' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'agent'

                { Get-SearchCount -Context $context -Query 'type:ticket' } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/search/count\.json\?query=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-SearchCount -Context $context -Query 'type:ticket' } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-SearchCount -Context $context -Query 'type:ticket' } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-SearchCount -Context $context -Query 'type:ticket' } | Should -Not -Throw
            }
        }

    }

}
