filter Measure-ScriptPerformance {
    <#
        .SYNOPSIS
            A wrapper for Measure-Command to run commands multiple times and report averages (avg, min, max)
    #>
    param(
        # The script to measure
        [Parameter(ValueFromPipeline)]
        [ScriptBlock]$Expression,

        # Number of iterations to run
        [int]$Count = 1000
    )
    @(1..$Count).ForEach{ Measure-Command $Expression } |
        Measure-Object TotalMilliseconds -Average -Minimum -Maximum -Sum |
        ForEach-Object {
            [PSCustomObject]@{
                PSTypeName = "ScriptRunTimings"
                "Avg(ms)"  = $_.Average
                "Max(ms)"  = $_.Maximum
                "Min(ms)"  = $_.Minimum
                "Sum(ms)"  = $_.Sum
                Expression = $Expression
                Count      = $_.Count
            }
        }
}

Update-TypeData -TypeName ScriptRunTimings -DefaultDisplayPropertySet "Avg(ms)", "Max(ms)", "Min(ms)", Expression -Force