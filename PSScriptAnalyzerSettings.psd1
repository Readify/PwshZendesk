@{
    IncludeRules = @(
        'PSAlignAssignmentStatement',
        'PSAvoid*',
        'PSDSC*',
        'PSMisleadingBacktick',
        'PSMissingModuleManifestField',
        'PSPlaceCloseBrace',
        'PSPlaceOpenBrace',
        'PSPossibleIncorrectComparisonWithNull',
        'PSPossibleIncorrectUsageOfAssignmentOperator',
        'PSPossibleIncorrectUsageOfRedirectionOperator',
        'PSProvideCommentHelp',
        'PSReservedCmdletChar',
        'PSReservedParams',
        'PSShouldProcess',
        'PSUse*'
    )

    Rules = @{
        PSPlaceOpenBrace = @{
            Enable             = $true
            OnSameLine         = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
        }

        PSPlaceCloseBrace = @{
            Enable             = $true
            NewLineAfter       = $false
            IgnoreOneLineBlock = $true
            NoEmptyLineBefore  = $false
        }

        PSUseConsistentIndentation = @{
            Enable              = $true
            Kind                = 'space'
            PipelineIndentation = 'IncreaseIndentationForFirstPipeline'
            IndentationSize     = 4
        }

        PSUseConsistentWhitespace = @{
            Enable          = $true
            CheckInnerBrace = $true
            CheckOpenBrace  = $false # incorrectly flags all `Should -Throw` Pester assertions
            CheckOpenParen  = $true
            CheckOperator   = $false # conflicts with `PSAlignAssignmentStatement`
            CheckPipe       = $true
            CheckSeparator  = $true
            CheckParameter  = $true
        }

        PSAlignAssignmentStatement = @{
            Enable         = $true
            CheckHashtable = $true
        }

        PSUseCorrectCasing = @{
            Enable = $true
        }
    }

    Severity = @(
        'Error'
        'Warning'
        'Information'
    )
}
