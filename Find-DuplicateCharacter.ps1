function Find-DuplicateCharacter {
    <#
        .SYNOPSIS
            Finds the first duplicate character in the input string $foo
        .EXAMPLE
            Find-DuplicateCharacter 'abcdedcba'

            # Returns the first duplicate character, 'd'
        .EXAMPLE
            $UnicodeString = $ExecutionContext.InvokeCommand.ExpandString(-join @(19968..40908).ForEach{"``u{$("{0:x}" -f $_)}"})
            $UnicodeString += $UnicodeString.ToCharArray() | Get-Random -OutVariable char
            $Result = Find-DuplicateCharacter $UnicodeString
            $Char -eq $Result

            # This example shows one way to test the function:
            # - How to generate a really long string of unique unicode characters
            # - How to guarantee it has a duplicate by appending a copy of a random character
            # - How to use Find-DuplicateCharacter to find the duplicate character
            # - How to verify the duplicate was the right character
    #>
    [CmdletBinding()]
    param(
        # An arbitrarily long string
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias("InputObject")]
        [string]$foo
    )
    process {
        $unique = [System.Collections.Generic.HashSet[char]]::new()
        for ($i = 0; $i -lt $foo.Length; $i++) {
            if (-not $unique.Add($foo[$i])) {
                $foo[$i]
                return
            }
        }
    }
}
