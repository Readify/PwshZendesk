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

        Mock -ModuleName PwshZendesk Invoke-RestMethod { [PSCustomObject]@{ users = $null; user = $null; deleted_user = $null; deleted_users = $null } }

        Context 'List Users' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-User -Context $context } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-User -Context $context } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-User -Context $context } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-User -Context $context } | Should -Not -Throw
            }

        }

        Context 'List Users by group' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-User -Context $context -GroupId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/groups/\d+/users\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-User -Context $context -GroupId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-User -Context $context -GroupId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-User -Context $context -GroupId 1 } | Should -Not -Throw
            }

        }

        Context 'List Users by organization' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-User -Context $context -OrganizationId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/organizations/\d+/users\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-User -Context $context -OrganizationId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-User -Context $context -OrganizationId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-User -Context $context -OrganizationId 1 } | Should -Not -Throw
            }

        }

        Context 'Show User' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-User -Context $context -Id 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-User -Context $context -Id 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-User -Context $context -Id 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-User -Context $context -Id 1 } | Should -Not -Throw
            }

        }

        Context 'Show Many Users' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-User -Context $context -Id @(1..5) } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users/show_many\.json\?ids=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-User -Context $context -Id @(1..5) } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-User -Context $context -Id @(1..5) } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-User -Context $context -Id @(1..5) } | Should -Not -Throw
            }

        }

        Context 'Show Many Users by external id' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-User -Context $context -ExternalId @(1..5) } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users/show_many\.json\?external_ids=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-User -Context $context -ExternalId @(1..5) } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-User -Context $context -ExternalId @(1..5) } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-User -Context $context -ExternalId @(1..5) } | Should -Not -Throw
            }

        }

        Context 'User related information' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-UserRelated -Context $context -UserId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users/\d+/related\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-UserRelated -Context $context -UserId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-UserRelated -Context $context -UserId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-UserRelated -Context $context -UserId 1 } | Should -Not -Throw
            }

        }

        Context 'Create User' {

            It 'Is not implemented' {
                { Search-User -Context $context } | Should -Throw 'The method or operation is not implemented.'
            }

            # It 'Matches the endpoint' {
            #     if ($IsInteractive) {
            #         throw 'Please run test in non-interactive mode'
            #     }

            #     $context.User.role = 'admin'

            #     { Add-User -Context $context } | Should -Not -Throw
            #     Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/users\.json' } -Scope It
            # }

            # It 'Does not allow end users to call' {
            #     $context.User.role = 'end-user'

            #     { Add-User -Context $context } | Should -Throw 'Authenticated user must have role'
            # }

            # It 'Allows agents to call' {
            #     $context.User.role = 'agent'

            #     { Add-User -Context $context } | Should -Not -Throw
            # }

            # It 'Allows admins to call' {
            #     $context.User.role = 'admin'

            #     { Add-User -Context $context } | Should -Not -Throw
            # }

        }

        Context 'Create Or Update User' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Set-User -Context $context -Email 'name@company.net' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/users/create_or_update\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Set-User -Context $context -Email 'name@company.net' -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Set-User -Context $context -Email 'name@company.net' -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Set-User -Context $context -Email 'name@company.net' -Confirm:$false } | Should -Not -Throw
            }

        }

        Context 'Create Or Update Many Users' {

            $users = @(
                [PSCustomObject]@{ email = 'rob@company.net' }
                [PSCustomObject]@{ email = 'ross@company.net' }
                [PSCustomObject]@{ email = 'russel@company.net' }
            )

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Set-User -Context $context -User $users -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/users/create_or_update_many\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Set-User -Context $context -User $users -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Set-User -Context $context -User $users -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Set-User -Context $context -User $users -Confirm:$false } | Should -Not -Throw
            }

        }

        Context 'Merge Self With Another User' {} # end-user PUT /api/v2/users/me/merge.json

        Context 'Merge End Users' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Merge-User -Context $context -UserId 1 -TargetUserId 2 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/users/\d+/merge\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Merge-User -Context $context -UserId 1 -TargetUserId 2 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Merge-User -Context $context -UserId 1 -TargetUserId 2 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Merge-User -Context $context -UserId 1 -TargetUserId 2 -Confirm:$false } | Should -Not -Throw
            }

        }

        Context 'Create Many Users' {

            It 'Is not implemented' {
                { Search-User -Context $context } | Should -Throw 'The method or operation is not implemented.'
            }

            # It 'Matches the endpoint' {
            #     if ($IsInteractive) {
            #         throw 'Please run test in non-interactive mode'
            #     }

            #     $context.User.role = 'admin'

            #     { Add-User -Context $context } | Should -Not -Throw
            #     Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/users/create_many\.json' } -Scope It
            # }

            # It 'Does not allow end users to call' {
            #     $context.User.role = 'end-user'

            #     { Add-User -Context $context } | Should -Throw 'Authenticated user must have role'
            # }

            # It 'Allows agents to call' {
            #     $context.User.role = 'agent'

            #     { Add-User -Context $context } | Should -Not -Throw
            # }

            # It 'Allows admins to call' {
            #     $context.User.role = 'admin'

            #     { Add-User -Context $context } | Should -Not -Throw
            # }

        }

        Context 'Update User' {

            It 'Is not implemented' {
                { Search-User -Context $context } | Should -Throw 'The method or operation is not implemented.'
            }

            # It 'Matches the endpoint' {
            #     if ($IsInteractive) {
            #         throw 'Please run test in non-interactive mode'
            #     }

            #     $context.User.role = 'admin'

            #     { Update-User -Context $context } | Should -Not -Throw
            #     Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/users/\d+\.json' } -Scope It
            # }

            # It 'Does not allow end users to call' {
            #     $context.User.role = 'end-user'

            #     { Update-User -Context $context } | Should -Throw 'Authenticated user must have role'
            # }

            # It 'Allows agents to call' {
            #     $context.User.role = 'agent'

            #     { Update-User -Context $context } | Should -Not -Throw
            # }

            # It 'Allows admins to call' {
            #     $context.User.role = 'admin'

            #     { Update-User -Context $context } | Should -Not -Throw
            # }

        }

        Context 'Update Many Users' {

            It 'Is not implemented' {
                { Search-User -Context $context } | Should -Throw 'The method or operation is not implemented.'
            }

            # It 'Matches the endpoint' {
            #     if ($IsInteractive) {
            #         throw 'Please run test in non-interactive mode'
            #     }

            #     $context.User.role = 'admin'

            #     { Update-User -Context $context } | Should -Not -Throw
            #     Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/users/update_many\.json' } -Scope It
            # }

            # It 'Does not allow end users to call' {
            #     $context.User.role = 'end-user'

            #     { Update-User -Context $context } | Should -Throw 'Authenticated user must have role'
            # }

            # It 'Allows agents to call' {
            #     $context.User.role = 'agent'

            #     { Update-User -Context $context } | Should -Not -Throw
            # }

            # It 'Allows admins to call' {
            #     $context.User.role = 'admin'

            #     { Update-User -Context $context } | Should -Not -Throw
            # }

        }

        Context 'Update Many Users by id' {

            It 'Is not implemented' {
                { Search-User -Context $context } | Should -Throw 'The method or operation is not implemented.'
            }

            # It 'Matches the endpoint' {
            #     if ($IsInteractive) {
            #         throw 'Please run test in non-interactive mode'
            #     }

            #     $context.User.role = 'admin'

            #     { Update-User -Context $context } | Should -Not -Throw
            #     Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/users/update_many\.json\?ids=' } -Scope It
            # }

            # It 'Does not allow end users to call' {
            #     $context.User.role = 'end-user'

            #     { Update-User -Context $context } | Should -Throw 'Authenticated user must have role'
            # }

            # It 'Allows agents to call' {
            #     $context.User.role = 'agent'

            #     { Update-User -Context $context } | Should -Not -Throw
            # }

            # It 'Allows admins to call' {
            #     $context.User.role = 'admin'

            #     { Update-User -Context $context } | Should -Not -Throw
            # }

        }

        Context 'Update Many Users by external id' {

            It 'Is not implemented' {
                { Search-User -Context $context } | Should -Throw 'The method or operation is not implemented.'
            }

            # It 'Matches the endpoint' {
            #     if ($IsInteractive) {
            #         throw 'Please run test in non-interactive mode'
            #     }

            #     $context.User.role = 'admin'

            #     { Update-User -Context $context } | Should -Not -Throw
            #     Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/users/update_many\.json\?external_ids=' } -Scope It
            # }

            # It 'Does not allow end users to call' {
            #     $context.User.role = 'end-user'

            #     { Update-User -Context $context } | Should -Throw 'Authenticated user must have role'
            # }

            # It 'Allows agents to call' {
            #     $context.User.role = 'agent'

            #     { Update-User -Context $context } | Should -Not -Throw
            # }

            # It 'Allows admins to call' {
            #     $context.User.role = 'admin'

            #     { Update-User -Context $context } | Should -Not -Throw
            # }

        }

        Context 'Bulk Deleting Users' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-User -Context $context -Id @(1..5) -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/users/destroy_many\.json\?ids=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-User -Context $context -Id @(1..5) -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Remove-User -Context $context -Id @(1..5) -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-User -Context $context -Id @(1..5) -Confirm:$false } | Should -Not -Throw
            }

        }

        Context 'Bulk Deleting Users by external id' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-User -Context $context -ExternalId 1 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/users/destroy_many\.json\?external_ids=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-User -Context $context -ExternalId 1 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Remove-User -Context $context -ExternalId 1 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-User -Context $context -ExternalId 1 -Confirm:$false } | Should -Not -Throw
            }

        }

        Context 'Bulk Deleting Users by external id bulk' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-User -Context $context -ExternalId @(1..5) -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/users/destroy_many\.json\?external_ids=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-User -Context $context -ExternalId @(1..5) -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Remove-User -Context $context -ExternalId @(1..5) -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-User -Context $context -ExternalId @(1..5) -Confirm:$false } | Should -Not -Throw
            }

        }

        Context 'Delete User' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-User -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/users/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-User -Context $context -Id 1 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Remove-User -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-User -Context $context -Id 1 -Confirm:$false } | Should -Not -Throw
            }

        }

        Context 'Search Users by query' {
            It 'Is not implemented' {
                { Search-User -Context $context } | Should -Throw 'The method or operation is not implemented.'
            }
        } # agent GET /api/v2/users/search.json?query={query}

        Context 'Search Users by externalid' {
            It 'Is not implemented' {
                { Search-User -Context $context } | Should -Throw 'The method or operation is not implemented.'
            }
        } # agent GET /api/v2/users/search.json?external_id={external_id}

        Context 'Autocomplete Users' {
            It 'Is not implemented' {
                { Get-AutocompleteUser -Context $context } | Should -Throw 'The method or operation is not implemented.'
            }
        } # agent GET /api/v2/users/autocomplete.json?name={name}

        Context 'Request User Create' {
            It 'Is not implemented' {
                { Request-UserLicense -Context $context } | Should -Throw 'The method or operation is not implemented.'
            }
        } # agent POST /api/v2/users/request_create.json

        Context 'List Deleted Users' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-DeletedUser -Context $context } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/deleted_users\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-DeletedUser -Context $context } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-DeletedUser -Context $context } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-DeletedUser -Context $context } | Should -Not -Throw
            }

        }

        Context 'Show Deleted User' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-DeletedUser -Context $context -UserId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/deleted_users/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-DeletedUser -Context $context -UserId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-DeletedUser -Context $context -UserId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-DeletedUser -Context $context -UserId 1 } | Should -Not -Throw
            }
        }

        Context 'Permanently Delete User' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-User -Context $context -Id 1 -Permanent -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/deleted_users/\d+\.json' } -Scope It
            }

            It 'Does not allow bulk permant delete' {
                $context.User.role = 'admin'

                { Remove-User -Context $context -Id @(1..5) -Permanent -Confirm:$false } | Should -Throw 'Can only permanently delete one user at a time'
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-User -Context $context -Id 1 -Permanent -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Remove-User -Context $context -Id 1 -Permanent -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-User -Context $context -Id 1 -Permanent -Confirm:$false } | Should -Not -Throw
            }

        }

        Context 'Show Compliance Deletion Statuses' {
            It 'Is not implemented' {
                { Get-UserGDPRStatus -Context $context } | Should -Throw 'The method or operation is not implemented.'
            }
        } #agent GET /api/v2/users/{id}/compliance_deletion_statuses.json

        Context 'Show the Current User' {

            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-AuthenticatedUser -Context $context } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users/me\.json' } -Scope It
            }

            It 'Allows end users to call' {
                $context.User.role = 'end-user'

                { Get-AuthenticatedUser -Context $context } | Should -Not -Throw
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-AuthenticatedUser -Context $context } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-AuthenticatedUser -Context $context } | Should -Not -Throw
            }

        }

    }

}
