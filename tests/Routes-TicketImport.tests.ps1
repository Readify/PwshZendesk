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

        Mock -ModuleName PwshZendesk Invoke-RestMethod { [PSCustomObject]@{ group = $null; groups = $null } }

        Context 'Ticket Import' {
            $ticket = [PSCustomObject]@{ requester_id = 1; description = 'Body'; subject = 'Title' }

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Import-Ticket -Context $context -Ticket $ticket } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/imports/tickets.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Import-Ticket -Context $context -Ticket $ticket } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Import-Ticket -Context $context -Ticket $ticket } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Import-Ticket -Context $context -Ticket $ticket } | Should -Not -Throw
            }
        }

        Context 'Ticket Bulk Import' {
            $tickets = @(
                [PSCustomObject]@{ requester_id = 1; description = 'Body1'; subject = 'Title1' }
                [PSCustomObject]@{ requester_id = 2; description = 'Body2'; subject = 'Title2' }
                [PSCustomObject]@{ requester_id = 3; description = 'Body3'; subject = 'Title3' }
            )

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Import-Ticket -Context $context -Ticket $tickets } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/imports/tickets/create_many.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Import-Ticket -Context $context -Ticket $tickets } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Import-Ticket -Context $context -Ticket $tickets } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Import-Ticket -Context $context -Ticket $tickets } | Should -Not -Throw
            }
        }

    }

}
