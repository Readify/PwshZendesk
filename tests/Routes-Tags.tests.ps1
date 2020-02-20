[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'Tags Routes' {

    InModuleScope PwshZendesk {

        $IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

        $context = @{
            Organization = 'company'
            BaseUrl      = 'https://company.testdesk.com'
            Credential   = [System.Management.Automation.PSCredential]::New('email', ('api-key' | ConvertTo-SecureString -AsPlainText -Force))
            User         = [PSCustomObject]@{ role = '' }
        }
        $context | Add-Member -TypeName 'ZendeskContext'

        Mock -ModuleName PwshZendesk Invoke-RestMethod { [PSCustomObject]@{ tags = $null } }

        Context 'List Tags' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-Tag -Context $context } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/tags.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-Tag -Context $context } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Get-Tag -Context $context } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-Tag -Context $context } | Should -Not -Throw
            }
        }

        Context 'Show Tags by ticket' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-Tag -Context $context -TicketId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/tickets/\d+/tags\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-Tag -Context $context -TicketId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-Tag -Context $context -TicketId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-Tag -Context $context -TicketId 1 } | Should -Not -Throw
            }
        }

        Context 'Show Tags by org' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-Tag -Context $context -OrganizationId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/organizations/\d+/tags\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-Tag -Context $context -OrganizationId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-Tag -Context $context -OrganizationId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-Tag -Context $context -OrganizationId 1 } | Should -Not -Throw
            }
        }

        Context 'Show Tags by user' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-Tag -Context $context -UserId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users/\d+/tags\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-Tag -Context $context -UserId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-Tag -Context $context -UserId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-Tag -Context $context -UserId 1 } | Should -Not -Throw
            }
        }

        Context 'Set Tags on ticket' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Set-Tag -Context $context -TicketId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/tickets/\d+/tags\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Set-Tag -Context $context -TicketId 1 -Tag 'Delivery' -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Set-Tag -Context $context -TicketId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Set-Tag -Context $context -TicketId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Set Tags on org' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Set-Tag -Context $context -OrganizationId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/organizations/\d+/tags.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Set-Tag -Context $context -OrganizationId 1 -Tag 'Delivery' -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Set-Tag -Context $context -OrganizationId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Set-Tag -Context $context -OrganizationId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Set Tags on user' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Set-Tag -Context $context -UserId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/users/\d+/tags.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Set-Tag -Context $context -UserId 1 -Tag 'Delivery' -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Set-Tag -Context $context -UserId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Set-Tag -Context $context -UserId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Add Tags to ticket' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Add-Tag -Context $context -TicketId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/tickets/\d+/tags.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Add-Tag -Context $context -TicketId 1 -Tag 'Delivery' -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Add-Tag -Context $context -TicketId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Add-Tag -Context $context -TicketId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Add Tags to org' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Add-Tag -Context $context -OrganizationId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/organizations/\d+/tags.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Add-Tag -Context $context -OrganizationId 1 -Tag 'Delivery' -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Add-Tag -Context $context -OrganizationId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Add-Tag -Context $context -OrganizationId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Add Tags to user' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Add-Tag -Context $context -UserId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/users/\d+/tags.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Add-Tag -Context $context -UserId 1 -Tag 'Delivery' -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Add-Tag -Context $context -UserId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Add-Tag -Context $context -UserId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Remove Tags from ticket' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-Tag -Context $context -TicketId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/tickets/\d+/tags\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-Tag -Context $context -TicketId 1 -Tag 'Delivery' -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Remove-Tag -Context $context -TicketId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-Tag -Context $context -TicketId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Remove Tags from org' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-Tag -Context $context -OrganizationId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/organizations/\d+/tags.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-Tag -Context $context -OrganizationId 1 -Tag 'Delivery' -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Remove-Tag -Context $context -OrganizationId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-Tag -Context $context -OrganizationId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Remove Tags from user' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-Tag -Context $context -UserId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/users/\d+/tags.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-Tag -Context $context -UserId 1 -Tag 'Delivery' -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Remove-Tag -Context $context -UserId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-Tag -Context $context -UserId 1 -Tag 'Delivery' -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Autocomplete Tags' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-Tag -Context $context -PartialName 'Deliv' } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/autocomplete/tags\.json\?name=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-Tag -Context $context -PartialName 'Deliv' } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-Tag -Context $context -PartialName 'Deliv' } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-Tag -Context $context -PartialName 'Deliv' } | Should -Not -Throw
            }
        }

    }

}
