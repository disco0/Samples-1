function Find-DuplicateCharacter {
    <#
        .SYNOPSIS
            Finds the first duplicate character in the input string $foo
        .EXAMPLE
            Find-DuplicateCharacter 'abcdedcba'

            # Returns the first duplicate character, 'd'
    #>
    [CmdletBinding()]
    param(
        # An arbitrarily long string
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$foo
    )
    $unique = [System.Collections.Generic.HashSet[char]]::new()
    for ($i = 0; $i -lt $foo.Length; $i++) {
        if (-not $unique.Add($foo[$i])) {
            $foo[$i]
            return
        }
    }
}
