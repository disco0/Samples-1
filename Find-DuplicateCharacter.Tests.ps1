Describe "Find-DuplicateCharacter" {
    BeforeAll {
        . $PSScriptRoot\Measure-ScriptPerformance.ps1
        . $PSScriptRoot\Find-DuplicateCharacter.ps1
    }

    $EastAsian = $ExecutionContext.InvokeCommand.ExpandString(
        -join (@(0x2E80..0x2FD5) + @(0x3190..0x319f) + @(0x3400..0x4DBF) + @(0x4E00..0x9FCC) + @(0xF900..0xFAAD)).ForEach{ "``u{$("{0:x}" -f $_)}" }
    )

    $TestCases = @(
        # Pathalogically, the spec example
        @{ ExpectedResult = 'd'; InputObject = "abcdedcba" }
        # Stuff that looks like numbers should work
        @{ ExpectedResult = '1'; InputObject = "112233445566778899" }
        # Longer string with the duplicate at the front
        @{ ExpectedResult = 'a'; InputObject = "aabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()ABCDEFGHIJKLMNOPQRSTUVWXYZ,<>./?;:'[{]}_-+=" }
        # Longer string with the duplicate at the very end
        @{ ExpectedResult = '+'; InputObject = "abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()ABCDEFGHIJKLMNOPQRSTUVWXYZ,<>./?;:'[{]}_-=++" }
        # A couple of normal cases
        @{ ExpectedResult = 'g'; InputObject = "abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()gABCDEFGHIJKLMNOPQRSTUVWXYZ,<>./?;:'[{]}_-+=" }
        @{ ExpectedResult = 'z'; InputObject = "abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()ABCDEFGHIJKLMNOPQRSTUVWXYZ,<>./?;:'[{]}_-+=zyxwvutsrqponmlkjihgfedcba" }
        # Pathologically long, all 28k chinese characters
        # Without any duplicates
        @{ ExpectedResult = $null; InputObject = $EastAsian }
        # Random duplicates at the end
        @{ ExpectedResult = ($ch = $EastAsian.ToCharArray() | Get-Random); InputObject = $EastAsian + $ch }
        @{ ExpectedResult = ($ch = $EastAsian.ToCharArray() | Get-Random); InputObject = $EastAsian + $ch }
        @{ ExpectedResult = ($ch = $EastAsian.ToCharArray() | Get-Random); InputObject = $EastAsian + $ch }
        # Random duplicates in the middle
        @{ ExpectedResult = ($ch = $EastAsian.ToCharArray() | Get-Random); InputObject = $EastAsian.Replace($EastAsian[(Get-Random -min 0 -max 28e3)], $ch) }
        @{ ExpectedResult = ($ch = $EastAsian.ToCharArray() | Get-Random); InputObject = $EastAsian.Replace($EastAsian[(Get-Random -min 0 -max 28e3)], $ch) }
        @{ ExpectedResult = ($ch = $EastAsian.ToCharArray() | Get-Random); InputObject = $EastAsian.Replace($EastAsian[(Get-Random -min 0 -max 28e3)], $ch) }

    ) | ForEach-Object { $_.Substring = $_.InputObject.SubString(0, 8); $_ }

    It "Returns <ExpectedResult> for <Substring>..." -TestCases $TestCases {
        param($ExpectedResult, $InputObject)
        $InputObject | Find-DuplicateCharacter | Should -Be $ExpectedResult
    }

    It "Runs small samples 1000x in under 100ms" -TestCases $TestCases.Where{$_.InputObject.Length -lt 120} {
        param($ExpectedResult, $InputObject)
        Measure-ScriptPerformance { $InputObject | Find-DuplicateCharacter } -Count 1000 | Select-Object -Expand "Sum(ms)" | Should -BeLessThan 100
    }

    It "Runs large samples 100x in under 1s" -TestCases $TestCases.Where{ $_.InputObject.Length -gt 28e3 } {
        param($ExpectedResult, $InputObject)
        Measure-ScriptPerformance { $InputObject | Find-DuplicateCharacter } -Count 100 | Select-Object -Expand "Sum(ms)" | Should -BeLessThan 1000
    }

}