[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'Users Routes' {

    InModuleScope PwshZendesk {

        $IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

        $context = @{
            Organization = 'company'
            BaseUrl      = 'https://company.testdesk.com'
            Credential   = [System.Management.Automation.PSCredential]::New('email', ('api-key' | ConvertTo-SecureString -AsPlainText -Force))
            User         = [PSCustomObject]@{ role = '' }
        }
        $context | Add-Member -TypeName 'ZendeskContext'

        Mock -ModuleName PwshZendesk Invoke-RestMethod { [PSCustomObject]@{ organization_membership = $null; organization_memberships = $null } }

        Context 'List Memberships' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-OrganizationMembership -Context $context } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/organization_memberships\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-OrganizationMembership -Context $context } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-OrganizationMembership -Context $context } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-OrganizationMembership -Context $context } | Should -Not -Throw
            }
        }

        Context 'List Memberships by user' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-OrganizationMembership -Context $context -UserId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users/\d+/organization_memberships\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-OrganizationMembership -Context $context -UserId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-OrganizationMembership -Context $context -UserId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-OrganizationMembership -Context $context -UserId 1 } | Should -Not -Throw
            }
        }

        Context 'List Memberships by org' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-OrganizationMembership -Context $context -OrganizationID 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/organizations/\d+/organization_memberships.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-OrganizationMembership -Context $context -OrganizationID 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-OrganizationMembership -Context $context -OrganizationID 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-OrganizationMembership -Context $context -OrganizationID 1 } | Should -Not -Throw
            }
        }

        Context 'Show Membership' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-OrganizationMembership -Context $context -Id 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/organization_memberships/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-OrganizationMembership -Context $context -Id 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-OrganizationMembership -Context $context -Id 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-OrganizationMembership -Context $context -Id 1 } | Should -Not -Throw
            }
        }

        Context 'Show Membership by user' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-OrganizationMembership -Context $context -UserId 1 -Id 2 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users/\d+/organization_memberships/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-OrganizationMembership -Context $context -UserId 1 -Id 2 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-OrganizationMembership -Context $context -UserId 1 -Id 2 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-OrganizationMembership -Context $context -UserId 1 -Id 2 } | Should -Not -Throw
            }
        }

        Context 'Create Membership' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { New-OrganizationMembership -Context $context -OrganizationId 1 -UserId 2 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/organization_memberships\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { New-OrganizationMembership -Context $context -OrganizationId 1 -UserId 2 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { New-OrganizationMembership -Context $context -OrganizationId 1 -UserId 2 -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { New-OrganizationMembership -Context $context -OrganizationId 1 -UserId 2 -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Create Many Memberships' {
            $memberships = @(
                [PSCustomObject]@{ OrganizationId = 1; UserId = 2 }
                [PSCustomObject]@{ OrganizationId = 1; UserId = 4 }
                [PSCustomObject]@{ OrganizationId = 3; UserId = 2 }
            )

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { New-OrganizationMembership -Context $context -Membership $memberships -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/organization_memberships/create_many.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { New-OrganizationMembership -Context $context -Membership $memberships -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { New-OrganizationMembership -Context $context -Membership $memberships -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { New-OrganizationMembership -Context $context -Membership $memberships -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Delete Membership' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-OrganizationMembership -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/organization_memberships/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-OrganizationMembership -Context $context -Id 1 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Remove-OrganizationMembership -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-OrganizationMembership -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Delete Membership by user' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-OrganizationMembership -Context $context -Id 1 -UserId 2 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/users/\d+/organization_memberships/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-OrganizationMembership -Context $context -Id 1 -UserId 2 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Remove-OrganizationMembership -Context $context -Id 1 -UserId 2 -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-OrganizationMembership -Context $context -Id 1 -UserId 2 -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Bulk Delete Memberships' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-OrganizationMembership -Context $context -Id @(1..5) -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/organization_memberships/destroy_many\.json\?ids=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-OrganizationMembership -Context $context -Id @(1..5) -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Remove-OrganizationMembership -Context $context -Id @(1..5) -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-OrganizationMembership -Context $context -Id @(1..5) -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Set Membership as Default' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Set-OrganizationMembershipAsDefault -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/users/\d+/organization_memberships/\d+/make_default\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Set-OrganizationMembershipAsDefault -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Set-OrganizationMembershipAsDefault -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Set-OrganizationMembershipAsDefault -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
            }
        }

    }

}
