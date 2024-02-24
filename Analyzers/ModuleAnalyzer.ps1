$scanResult = Invoke-ScriptAnalyzer -Path $PSScriptRoot\..\Modules -Recurse -IncludeDefaultRules -ReportSummary -EnableExit
Write-Host "Hello"