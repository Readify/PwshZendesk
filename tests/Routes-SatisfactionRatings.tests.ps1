[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
Param()

Import-Module "$PSScriptRoot/../PwshZendesk.psm1" -Force

Describe 'Satisfaction Rating Routes' {

    InModuleScope PwshZendesk {

        $IsInteractive = [Environment]::GetCommandLineArgs() -join ' ' -notmatch '-NonI'

        $context = @{
            Organization = 'company'
            BaseUrl      = 'https://company.testdesk.com'
            Credential   = [System.Management.Automation.PSCredential]::New('email', ('api-key' | ConvertTo-SecureString -AsPlainText -Force))
            User         = [PSCustomObject]@{ role = '' }
        }
        $context | Add-Member -TypeName 'ZendeskContext'

        Mock -ModuleName PwshZendesk Invoke-RestMethod { [PSCustomObject]@{ satisfaction_rating = $null; satisfaction_ratings = $null } }

        Context 'List Satisfaction Ratings' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-SatisfactionRating -Context $context } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/satisfaction_ratings\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-SatisfactionRating -Context $context } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Get-SatisfactionRating -Context $context } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-SatisfactionRating -Context $context } | Should -Not -Throw
            }
        }

        Context 'Show Satisfaction Rating' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'admin'

                { Get-SatisfactionRating -Context $context -Id 1 } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Get' -and $Uri -match '/api/v2/satisfaction_ratings/\d+\.json' } -Scope It
            }

            It 'Does not allow end users to call' {
                $context.User.role = 'end-user'

                { Get-SatisfactionRating -Context $context -Id 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { Get-SatisfactionRating -Context $context -Id 1 } | Should -Throw 'Authenticated user must have role'
            }

            It 'Allows admins to call' {
                $context.User.role = 'admin'

                { Get-SatisfactionRating -Context $context -Id 1 } | Should -Not -Throw
            }
        }

        Context 'Create a Satisfaction Rating' {
            It 'Matches the endpoint' {
                if ($IsInteractive) {
                    throw 'Please run test in non-interactive mode'
                }

                $context.User.role = 'end-user'

                { New-SatisfactionRating -Context $context -TicketId 1 -Score 'good' -Confirm:$false } | Should -Not -Throw
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -match '/api/v2/tickets/\d+/satisfaction_rating\.json' } -Scope It
            }

            It 'Allows end users to call' {
                $context.User.role = 'end-user'

                { New-SatisfactionRating -Context $context -TicketId 1 -Score 'good' -Confirm:$false } | Should -Not -Throw
            }

            It 'Does not allow agents to call' {
                $context.User.role = 'agent'

                { New-SatisfactionRating -Context $context -TicketId 1 -Score 'good' -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }

            It 'Does not allow admins to call' {
                $context.User.role = 'admin'

                { New-SatisfactionRating -Context $context -TicketId 1 -Score 'good' -Confirm:$false } | Should -Throw 'Authenticated user must have role'
            }
        }

    }

}
