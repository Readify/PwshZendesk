[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'Groups Routes' {

    InModuleScope PwshZendesk {

        $IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

        $context = @{
            Organization = 'company'
            BaseUrl      = 'https://company.testdesk.com'
            Credential   = [System.Management.Automation.PSCredential]::New('email', ('api-key' | ConvertTo-SecureString -AsPlainText -Force))
            User         = [PSCustomObject]@{ role = '' }
        }
        $context | Add-Member -TypeName 'ZendeskContext'

        Mock -ModuleName PwshZendesk Invoke-RestMethod { [PSCustomObject]@{ suspended_ticket = $null; suspended_tickets = $null } }

        Context 'List Suspended Tickets' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-SuspendedTicket -Context $context } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/suspended_tickets.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-SuspendedTicket -Context $context } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-SuspendedTicket -Context $context } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-SuspendedTicket -Context $context } | Should -Not -Throw
            }
        } # GET /api/v2/suspended_tickets.json

        Context 'Show Suspended Ticket' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-SuspendedTicket -Context $context -Id 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/suspended_tickets/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-SuspendedTicket -Context $context -Id 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-SuspendedTicket -Context $context -Id 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-SuspendedTicket -Context $context -Id 1 } | Should -Not -Throw
            }
        } # GET /api/v2/suspended_tickets/{id}.json

        Context 'Recover Suspended Ticket' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Restore-SuspendedTicket -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/suspended_tickets/\d+/recover\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Restore-SuspendedTicket -Context $context -Id 1 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Restore-SuspendedTicket -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Restore-SuspendedTicket -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
            }
        } # PUT /api/v2/suspended_tickets/{id}/recover.json

        Context 'Recover Multiple Suspended Tickets' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Restore-SuspendedTicket -Context $context -Id @(1..5) -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/suspended_tickets/recover_many\.json\?ids=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Restore-SuspendedTicket -Context $context -Id @(1..5) -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Restore-SuspendedTicket -Context $context -Id @(1..5) -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Restore-SuspendedTicket -Context $context -Id @(1..5) -Confirm:$false } | Should -Not -Throw
            }
        } # PUT /api/v2/suspended_tickets/recover_many.json?ids={id1},{id2}

        Context 'Delete Suspended Ticket' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-SuspendedTicket -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/suspended_tickets/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-SuspendedTicket -Context $context -Id 1 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Remove-SuspendedTicket -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-SuspendedTicket -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
            }
        } # DELETE /api/v2/suspended_tickets/{id}.json

        Context 'Delete Multiple Suspended Tickets' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-SuspendedTicket -Context $context -Id @(1..5) -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/suspended_tickets/destroy_many\.json\?ids=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-SuspendedTicket -Context $context -Id @(1..5) -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Remove-SuspendedTicket -Context $context -Id @(1..5) -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-SuspendedTicket -Context $context -Id @(1..5) -Confirm:$false } | Should -Not -Throw
            }
        } # DELETE /api/v2/suspended_tickets/destroy_many.json?ids={id1},{id2}

    }

}
