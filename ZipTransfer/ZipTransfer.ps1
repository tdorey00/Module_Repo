#Author: tdorey Date: 7/28/22
#This script starts with a .zip Folder containing a directory with 3 text files and copys the contents of startZip: 
#TextEnd.zip
#   TextFolder
#       text1.txt
#       text2.txt
#       text3.txt
#to endZip while removing the directory above the Text Files, Should result in the following structure:
#TextEnd.zip
#   text1.txt
#   text2.txt
#   text3.txt

Add-Type -AssemblyName 'System.IO.Compression';
Add-Type -AssemblyName 'System.IO.Compression.FileSystem';

[string] $startPath = Join-Path $PSScriptRoot "TextStart.zip"
Write-Host "$(Get-Date) - Starting path is: " $startPath
[string] $endPath = Join-Path $PSScriptRoot "TextEnd.zip"
Write-Host "$(Get-Date) - Ending path is: " $endPath

[System.IO.Compression.ZipArchive] $startZip = [System.IO.Compression.ZipFile]::OpenRead($startPath)
[System.IO.Compression.ZipArchive] $endZip = [System.IO.Compression.ZipFile]::Open($endPath, [System.IO.Compression.ZipArchiveMode]::Update)
Write-Host "$(Get-Date) - Entries: "
foreach($entry in $startZip.Entries){
    if($null -ne $endZip.GetEntry($entry.FullName)){ #removes folder if it exists
        $endZip.GetEntry($entry.FullName).Delete()
    }
    $tempText = $entry.FullName.Substring(11) #removes subdirectory folder from copy process

    if($null -ne $endZip.GetEntry($tempText)){ #removes text files if they exist
        $endZip.GetEntry($tempText).Delete()
    }
    [System.IO.Stream] $copyStream = $endZip.CreateEntry($tempText).Open() #create stream setup to copy files to endZip
    Write-Host "$(Get-Date) - Copying $($entry.FullName) -> $($tempText)"
    $entry.Open().CopyTo($copyStream)

    $copyStream.Close()
}

$startZip.Dispose()
$endZip.Dispose()