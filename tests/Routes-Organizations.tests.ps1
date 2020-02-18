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

        Mock -ModuleName PwshZendesk Invoke-RestMethod { [PSCustomObject]@{ organization = $null; organizations = $null; organization_related = $null } }

        Context 'List Organizations' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-Organization -Context $context } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/organizations\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-Organization -Context $context } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-Organization -Context $context } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-Organization -Context $context } | Should -Not -Throw
            }
        }

        Context 'List Organizations by user' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-Organization -Context $context -UserId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users/\d+/organizations\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-Organization -Context $context -UserId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-Organization -Context $context -UserId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-Organization -Context $context -UserId 1 } | Should -Not -Throw
            }
        }

        Context 'Autocomplete Organizations' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-Organization -Context $context -PartialName 'Tels' } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/organizations/autocomplete\.json\?name=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-Organization -Context $context -PartialName 'Tels' } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-Organization -Context $context -PartialName 'Tels' } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-Organization -Context $context -PartialName 'Tels' } | Should -Not -Throw
            }
        }

        Context 'Show Organization;s Related Information' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-OrganizationRelated -Context $context -OrganizationId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/organizations/\d+/related\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-OrganizationRelated -Context $context -OrganizationId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-OrganizationRelated -Context $context -OrganizationId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-OrganizationRelated -Context $context -OrganizationId 1 } | Should -Not -Throw
            }
        }

        Context 'Show Organization' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-Organization -Context $context -Id 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/organizations/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-Organization -Context $context -Id 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-Organization -Context $context -Id 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-Organization -Context $context -Id 1 } | Should -Not -Throw
            }
        }

        Context 'Show Many Organizations' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-Organization -Context $context -Id @(1..5) } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/organizations/show_many\.json\?ids=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-Organization -Context $context -Id @(1..5) } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-Organization -Context $context -Id @(1..5) } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-Organization -Context $context -Id @(1..5) } | Should -Not -Throw
            }
        }

        Context 'Show Many Organizations by external id' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-Organization -Context $context -ExternalId @(1..5) } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/organizations/show_many\.json\?external_ids=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-Organization -Context $context -ExternalId @(1..5) } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-Organization -Context $context -ExternalId @(1..5) } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-Organization -Context $context -ExternalId @(1..5) } | Should -Not -Throw
            }
        }

        Context 'Create Organization' {
            It 'Is not implemented' {
                { New-Organization -Context $context -Confirm:$false } | Should -Throw 'The method or operation is not implemented.'
            }
        } # admin POST /api/v2/organizations.json

        Context 'Create Many Organizations' {
            It 'Is not implemented' {
                { Set-Organization -Context $context -Confirm:$false } | Should -Throw 'The method or operation is not implemented.'
            }
        } # agent POST /api/v2/organizations/create_many.json

        Context 'Create Or Update Organization' {
            It 'Is not implemented' {
                { Set-Organization -Context $context -Confirm:$false } | Should -Throw 'The method or operation is not implemented.'
            }
        } # agent POST /api/v2/organizations/create_or_update.json

        Context 'Update Organization' {
            It 'Is not implemented' {
                { Update-Organization -Context $context -Confirm:$false } | Should -Throw 'The method or operation is not implemented.'
            }
        } # admin PUT /api/v2/organizations/{id}.json

        Context 'Update Many Organizations' {
            It 'Is not implemented' {
                { Update-Organization -Context $context -Confirm:$false } | Should -Throw 'The method or operation is not implemented.'
            }
        } # admin PUT /api/v2/organizations/update_many.json

        Context 'Update Many Organizations by id' {
            It 'Is not implemented' {
                { Update-Organization -Context $context -Confirm:$false } | Should -Throw 'The method or operation is not implemented.'
            }
        } # admin PUT /api/v2/organizations/update_many.json?ids={ids}

        Context 'Update Many Organizations by external id' {
            It 'Is not implemented' {
                { Update-Organization -Context $context -Confirm:$false } | Should -Throw 'The method or operation is not implemented.'
            }
        } # admin PUT /api/v2/organizations/update_many.json?external_ids={external_ids}

        Context 'Delete Organization' {
            It 'Is not implemented' {
                { Remove-Organization -Context $context -Confirm:$false } | Should -Throw 'The method or operation is not implemented.'
            }
        } # admin DELETE /api/v2/organizations/{id}.json

        Context 'Bulk Delete Organizations' {
            It 'Is not implemented' {
                { Remove-Organization -Context $context -Confirm:$false } | Should -Throw 'The method or operation is not implemented.'
            }
        } # admin DELETE /api/v2/organizations/destroy_many.json?ids={ids}

        Context 'Bulk Delete Organizations by external id' {
            It 'Is not implemented' {
                { Remove-Organization -Context $context -Confirm:$false } | Should -Throw 'The method or operation is not implemented.'
            }
        } # admin DELETE /api/v2/organizations/destroy_many.json?external_ids={external_ids}

        Context 'Search Organizations by External ID' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-Organization -Context $context -ExternalId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/organizations/search\.json\?external_id=' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-Organization -Context $context -ExternalId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-Organization -Context $context -ExternalId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-Organization -Context $context -ExternalId 1 } | Should -Not -Throw
            }
        }

    }

}
