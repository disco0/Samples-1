This repository holds a few samples of PowerShell scripts that I'm keeping around for various reasons.

# Highlights

## Find-RecurringCharacter

This was written on request, and mostly it demonstrates the proper use of a hashset as a fast, case-sensitive lookup. A Hashset is a generic collection that's basically like the Keys of a hashtable. It doesn't allow Recurrings, and if you make it a `HashSet[char]` it is case-sensitive by default.

## Measure-ScriptPerformance

This serves as a wrapper for Measure-Command to run a scriptblock multiple times and report total (sum) and average (avg, min, max) run times.