Import-Module -Name $PSScriptRoot\DirectoryScanner -Force
#Get-Help -Name "Get-FileExtensionSizeList" -Full

#Test-Path -Path "C:\JavaWorkspace\.metadata\.lock" -PathType Container -IsValid
Get-FileExtensionSizeList -Directory "..\..\..\Users\Bossman\Documents" 


