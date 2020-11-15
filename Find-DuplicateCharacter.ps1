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
    foreach ($char in $foo.ToCharArray()) {
        if (-not $unique.Add($char)) {
            $char
            return
        }
    }
}
