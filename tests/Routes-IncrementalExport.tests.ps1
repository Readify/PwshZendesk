[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'Incremental Export Routes' {

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

        Context 'Incremental Ticket Export' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Export-Ticket -Context $context -Timestamp 0 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Uri -match '/api/v2/incremental/tickets\.json\?start_time=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Export-Ticket -Context $context -Timestamp 0 } | Should -Throw
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Export-Ticket -Context $context -Timestamp 0 } | Should -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Export-Ticket -Context $context -Timestamp 0 } | Should -Not -Throw
            }

        }

        Context 'Incremental Ticket Event Export' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Export-TicketEvent -Context $context -Timestamp 0 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/incremental/ticket_events\.json\?start_time=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Export-TicketEvent -Context $context -Timestamp 0 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Export-TicketEvent -Context $context -Timestamp 0 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Export-TicketEvent -Context $context -Timestamp 0 } | Should -Not -Throw
            }

        }

        Context 'Incremental Organization Export' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Export-Organization -Context $context -Timestamp 0 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/incremental/organizations\.json\?start_time=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Export-Organization -Context $context -Timestamp 0 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Export-Organization -Context $context -Timestamp 0 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Export-Organization -Context $context -Timestamp 0 } | Should -Not -Throw
            }

        }

        Context 'Incremental User Export' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Export-User -Context $context -Timestamp 0 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/incremental/users\.json\?start_time=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Export-User -Context $context -Timestamp 0 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Export-User -Context $context -Timestamp 0 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Export-User -Context $context -Timestamp 0 } | Should -Not -Throw
            }

        }

        Context 'Incremental Sample Export' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Export-Sample -Context $context -EntityName 'tickets' -Timestamp 0 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/incremental/(tickets|users|organizations)/sample.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Export-Sample -Context $context -EntityName 'tickets' -Timestamp 0 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Export-Sample -Context $context -EntityName 'tickets' -Timestamp 0 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Export-Sample -Context $context -EntityName 'tickets' -Timestamp 0 } | Should -Not -Throw
            }

        }

    }

}
