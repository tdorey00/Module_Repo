#Run this to analyize the Modules Folder for Violations before committing
Invoke-ScriptAnalyzer -Path $PSScriptRoot\..\Modules -Recurse -IncludeDefaultRules -ReportSummary
