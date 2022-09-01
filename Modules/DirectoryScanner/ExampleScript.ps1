Import-Module -Name $PSScriptRoot\DirectoryScanner -Force
#Get-Help -Name "Get-FileExtensionSizeList" -Detailed
$files = Get-ChildItem -Path "C:/Users/Bossman/Documents"
foreach($file in $files){
    if($file.Attributes -ieq "Archive"){
        Write-Host "$($file.BaseName): $($file.Length)"
    }
}