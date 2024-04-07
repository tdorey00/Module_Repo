<#
    This Script is used to generate the Documentation for HashtableHelper utilizing PlatyPS

    Author: Tyler Dorey
    Date: 3/15/2024

    References used:
    https://learn.microsoft.com/en-us/powershell/utility-modules/platyps/create-help-using-platyps?view=ps-modules
    https://mikefrobbins.com/2023/11/30/generating-powershell-module-documentation-with-platyps/

    Future Considerations: 
        - Possibly Make a generic script with parameters to potentially remove the need for this to be on a Per Module Basis

    IMPORTANT NOTES:
        - According to https://github.com/PowerShell/platyPS/issues/491 default values will not be automatically populated and must be filled out manually
#>

param(
    [CmdletBinding(PositionalBinding=$false)]

    #Use this in the case where we do not want MAML Files to be generated (In 90% of cases we want them to be generated)
    [Parameter(Mandatory=$false)]
    [switch]$SkipMAMLFileGeneration
)

#If platyps is not installed install it
if( -not (Get-Module -Name "platyps")) {
    Write-Host "$($MyInvocation.MyCommand) - $(Get-Date) - platyps not found installing..."
    Install-Module platyps -Scope CurrentUser -Force
}
else {
    Write-Host "$($MyInvocation.MyCommand) - $(Get-Date) - platyps found, skipping install."
}

#Imports
Write-Host "$($MyInvocation.MyCommand) - $(Get-Date) - Importing modules..."
Import-Module (Join-Path $PSScriptRoot "..\..\Modules\HashtableHelper") -Force
Import-Module platyps

#Configuration Vars
[string] $moduleName = "HashtableHelper"
[string] $markdownPath
[string] $mamlPath

#TODO Logging.

#Create Markdown Path if it does not exist
try {
    $markdownPath = Join-Path $PSScriptRoot "..\$moduleName" | Resolve-Path -ErrorAction Stop
}
catch {
    [string] $path = (Join-Path $PSScriptRoot "..\$moduleName")
    New-Item -ItemType Directory -Force -Path $path | Out-Null
    $markdownPath = $path | Resolve-Path
}

#Create MAML Path if it does not exist
try {
    $mamlPath = Join-Path $PSScriptRoot "..\..\Modules\$moduleName\en-US" | Resolve-Path -ErrorAction Stop
}
catch {
    [string] $path = (Join-Path $PSScriptRoot "..\..\Modules\$moduleName\en-US")
    New-Item -ItemType Directory -Force -Path $path | Out-Null
    $markdownPath = $path | Resolve-Path
}

#If the markdown doesn't currently exist we need to create it otherwise we can just update the existing
if((Get-ChildItem -Path $markdownPath\*.md).Count -eq 0) {

    $mdHelpParams = @{
        Module                = $moduleName
        OutputFolder          = $markdownPath
        AlphabeticParamsOrder = $true
        UseFullTypeName       = $true
        WithModulePage        = $true
        ExcludeDontShow       = $false
        Encoding              = [System.Text.Encoding]::UTF8
    }
    New-MarkdownHelp @mdHelpParams | Out-Null
}
else {

    $mdHelpParams = @{
        Path                  = $markdownPath
        AlphabeticParamsOrder = $true
        UseFullTypeName       = $true
        ExcludeDontShow       = $false
        Encoding              = [System.Text.Encoding]::UTF8
        Force                 = $true #Removes help files that no longer exists
        RefreshModulePage     = $true
    }
    
    # https://learn.microsoft.com/en-us/powershell/module/platyps/update-markdownhelpmodule?view=ps-modules#-modulepagepath
    Update-MarkdownHelpModule @mdHelpParams | Out-Null
}


if(-not $SkipMAMLFileGeneration) {

    #Use this to test if generation was successful
    #Get-HelpPreview -Path "$mamlPath\$moduleName-help.xml" -ErrorAction Stop
}
