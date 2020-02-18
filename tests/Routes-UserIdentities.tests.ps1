[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'User Identities Routes' {

    InModuleScope PwshZendesk {

        $IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

        $context = @{
            Organization = 'company'
            BaseUrl      = 'https://company.testdesk.com'
            Credential   = [System.Management.Automation.PSCredential]::New('email', ('api-key' | ConvertTo-SecureString -AsPlainText -Force))
            User         = [PSCustomObject]@{ role = '' }
        }
        $context | Add-Member -TypeName 'ZendeskContext'

        Mock -ModuleName PwshZendesk Invoke-RestMethod { [PSCustomObject]@{ identity = $null; identities = $null } }

        Context 'List Identities' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-UserIdentity -Context $context -UserId 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users/\d+/identities\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-UserIdentity -Context $context -UserId 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-UserIdentity -Context $context -UserId 1 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-UserIdentity -Context $context -UserId 1 } | Should -Not -Throw
            }
        }

        Context 'Show Identity' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-UserIdentity -Context $context -UserId 1 -Id 2 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/users/\d+/identities/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-UserIdentity -Context $context -UserId 1 -Id 2 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Get-UserIdentity -Context $context -UserId 1 -Id 2 } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-UserIdentity -Context $context -UserId 1 -Id 2 } | Should -Not -Throw
            }
        }

        Context 'Create Identity' {
            It 'Matches the agent endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { New-UserIdentity -Context $context -UserId 1 -Type 'email' -Value 'name@company.net' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/users/\d+/identities.json' } -Scope It
            }

            It 'Matches the end-user endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'end-user'

                { New-UserIdentity -Context $context -UserId 1 -Type 'email' -Value 'name@company.net' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/end_users/\d+/identities\.json' } -Scope It
            }

            It 'Allows end users to call' {
                $context.User.role = 'end-user'

                { New-UserIdentity -Context $context -UserId 1 -Type 'email' -Value 'name@company.net' -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { New-UserIdentity -Context $context -UserId 1 -Type 'email' -Value 'name@company.net' -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { New-UserIdentity -Context $context -UserId 1 -Type 'email' -Value 'name@company.net' -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Update Identity' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Update-UserIdentity -Context $context -UserId 1 -Id 2 -Value 'name@company.net' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/users/\d+/identities/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Update-UserIdentity -Context $context -UserId 1 -Id 2 -Value 'name@company.net' -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Update-UserIdentity -Context $context -UserId 1 -Id 2 -Value 'name@company.net' -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Update-UserIdentity -Context $context -UserId 1 -Id 2 -Value 'name@company.net' -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Make Identity Primary' {
            It 'Matches the agent endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'agent'

                { Set-UserIdentityAsPrimary -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/users/\d+/identities/\d+/make_primary' } -Scope It
            }

            It 'Matches the end user endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'end-user'

                { Set-UserIdentityAsPrimary -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/end_users/\d+/identities/\d+/make_primary' } -Scope It
            }

            It 'Allows end users to call' {
                $context.User.role = 'end-user'

                { Set-UserIdentityAsPrimary -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Set-UserIdentityAsPrimary -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Set-UserIdentityAsPrimary -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Verify Identity' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Set-UserIdentityAsVerified -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/users/\d+/identities/\d+/verify' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Set-UserIdentityAsVerified -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Set-UserIdentityAsVerified -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Set-UserIdentityAsVerified -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Request User Verification' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Send-UserIdentityVerification -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Put' -and $Uri -match '/api/v2/users/\d+/identities/\d+/request_verification\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Send-UserIdentityVerification -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Send-UserIdentityVerification -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Send-UserIdentityVerification -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
            }
        }

        Context 'Delete Identity' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Remove-UserIdentity -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -match '/api/v2/users/\d+/identities/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Remove-UserIdentity -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows agents to call' {
                $context.User.role = 'agent'

                { Remove-UserIdentity -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Remove-UserIdentity -Context $context -UserId 1 -Id 2 -Confirm:$false } | Should -Not -Throw
            }
        }

    }

}
