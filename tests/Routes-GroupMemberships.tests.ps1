[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'Group Memberships Routes' {

    InModuleScope PwshZendesk {

        $IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

        $context = @{
            Organization = 'company'
            BaseUrl      = 'https://company.testdesk.com'
            Credential   = [System.Management.Automation.PSCredential]::New('email', ('api-key' | ConvertTo-SecureString -AsPlainText -Force))
            User         = [PSCustomObject]@{ role = '' }
        }
        $context | Add-Member -TypeName 'ZendeskContext'

        Mock -ModuleName PwshZendesk Invoke-RestMethod { [PSCustomObject]@{ group_membership = $null; group_memberships = $null } }

        Context 'List Memberships' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/group_memberships\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-GroupMembership -Context $context } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-GroupMembership -Context $context } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context } | Should -Not -Throw
            }
        } # agent GET /api/v2/group_memberships.json

        Context 'List Memberships by user' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context -UserId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users/\d+/group_memberships\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-GroupMembership -Context $context -UserId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-GroupMembership -Context $context -UserId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context -UserId 1 } | Should -Not -Throw
            }
        } # agent GET /api/v2/users/{user_id}/group_memberships.json

        Context 'List Memberships by group' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context -GroupId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/groups/\d+/memberships\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-GroupMembership -Context $context -GroupId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-GroupMembership -Context $context -GroupId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context -GroupId 1 } | Should -Not -Throw
            }
        } # agent GET /api/v2/groups/{group_id}/memberships.json

        Context 'List Assignable Memberships' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context -Assignable } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/group_memberships/assignable\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-GroupMembership -Context $context -Assignable } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-GroupMembership -Context $context -Assignable } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context -Assignable } | Should -Not -Throw
            }
        } # agent GET /api/v2/group_memberships/assignable.json

        Context 'List Assignable Memberships by group' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context -GroupId 1 -Assignable } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/groups/\d+/memberships/assignable\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-GroupMembership -Context $context -GroupId 1 -Assignable } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-GroupMembership -Context $context -GroupId 1 -Assignable } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context -GroupId 1 -Assignable } | Should -Not -Throw
            }
        } # agent GET /api/v2/groups/{group_id}/memberships/assignable.json

        Context 'Show Membership' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context -Id 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/group_memberships/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-GroupMembership -Context $context -Id 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-GroupMembership -Context $context -Id 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context -Id 1 } | Should -Not -Throw
            }
        } # agent GET /api/v2/group_memberships/{id}.json

        Context 'Show Membership by user' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context -UserId 1 -Id 2 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users/\d+/group_memberships/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-GroupMembership -Context $context -UserId 1 -Id 2 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-GroupMembership -Context $context -UserId 1 -Id 2 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-GroupMembership -Context $context -UserId 1 -Id 2 } | Should -Not -Throw
            }
        } # agent GET /api/v2/users/{user_id}/group_memberships/{id}.json

        Context 'Create Membership' {
            $member = [PSCustomObject]@{ user_id = 1; group_id = 2}

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { New-GroupMembership -Context $context -Membership $member -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/group_memberships\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { New-GroupMembership -Context $context -Membership $member -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { New-GroupMembership -Context $context -Membership $member -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { New-GroupMembership -Context $context -Membership $member -Confirm:$false } | Should -Not -Throw
            }
        } # admin POST /api/v2/group_memberships.json

        Context 'Create Membership by user' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { New-GroupMembership -Context $context -UserId 1 -GroupId 2 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/users/\d+/group_memberships\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { New-GroupMembership -Context $context -UserId 1 -GroupId 2 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { New-GroupMembership -Context $context -UserId 1 -GroupId 2 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { New-GroupMembership -Context $context -UserId 1 -GroupId 2 -Confirm:$false } | Should -Not -Throw
            }
        } # admin POST /api/v2/users/{user_id}/group_memberships.json

        Context 'Bulk Create Memberships' {
            $members = @(
                [PSCustomObject]@{ user_id = 1; group_id = 2 }
                [PSCustomObject]@{ user_id = 3; group_id = 2 }
                [PSCustomObject]@{ user_id = 1; group_id = 4 }
            )

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { New-GroupMembership -Context $context -Membership $members -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/group_memberships/create_many\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { New-GroupMembership -Context $context -Membership $members -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { New-GroupMembership -Context $context -Membership $members -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { New-GroupMembership -Context $context -Membership $members -Confirm:$false } | Should -Not -Throw
            }
        } # admin POST /api/v2/group_memberships/create_many.json

        Context 'Delete Membership' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-GroupMembership -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/group_memberships/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-GroupMembership -Context $context -Id 1 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Remove-GroupMembership -Context $context -Id 1 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-GroupMembership -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
            }
        } # admin DELETE /api/v2/group_memberships/{id}.json

        Context 'Delete Membership by user' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-GroupMembership -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/users/\d+/group_memberships/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-GroupMembership -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Remove-GroupMembership -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-GroupMembership -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
            }
        } # admin DELETE /api/v2/users/{user_id}/group_memberships/{id}.json

        Context 'Bulk Delete Memberships' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-GroupMembership -Context $context -Id @(1..5) -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/group_memberships/destroy_many\.json\?ids=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-GroupMembership -Context $context -Id @(1..5) -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Remove-GroupMembership -Context $context -Id @(1..5) -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-GroupMembership -Context $context -Id @(1..5) -Confirm:$false } | Should -Not -Throw
            }
        } # admin DELETE /api/v2/group_memberships/destroy_many.json?ids={group_membership_ids}

        Context 'Set Membership as Default' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Set-GroupMembershipAsDefault -Context $context -UserId 1 -MembershipId 2 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/users/\d+/group_memberships/\d+/make_default\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Set-GroupMembershipAsDefault -Context $context -UserId 1 -MembershipId 2 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Set-GroupMembershipAsDefault -Context $context -UserId 1 -MembershipId 2 -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Set-GroupMembershipAsDefault -Context $context -UserId 1 -MembershipId 2 -Confirm:$false } | Should -Not -Throw
            }
        } # agent PUT /api/v2/users/{user_id}/group_memberships/{membership_id}/make_default.json

    }

}
