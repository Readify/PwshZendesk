function ConvertTo-UnicodeEscape {
    <#
    .SYNOPSIS
        Escapes non-ascii characters in a given string
    .DESCRIPTION
        Escapes non-ascii characters in a given string
    .EXAMPLE
        PS C:\> 'A Náme' | ConvertTo-UnicodeEscape

        Escapes the `á` to json compliant `\u00E1`
    .EXAMPLE
        PS C:\> $data | ConvertTo-Json -Compress | ConvertTo-UnicodeEscape

        Converts `$data` to json and escapes any non ascii characters
    #>
    [CmdletBinding()]
    Param (
        # String to escape
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String]
        $InputObject
    )

    $output = ''

    foreach ($char in $InputObject.GetEnumerator()) {
        $i = [int]$char

        if ($i -lt 128) {
            Write-Debug -Message "$char ($i) does not need escaping."
            $output += $char
        } else {
            Write-Debug -Message "$char ($i) needs escaping."

            $hex = '{0:X}' -f $i
            Write-Debug -Message "Character as hex: $hex"

            $escape = '\u' + $hex.PadLeft(4, '0')
            Write-Debug -Message "Full escape sequence: $escape"

            $output += $escape
        }
    }

    $output
}
