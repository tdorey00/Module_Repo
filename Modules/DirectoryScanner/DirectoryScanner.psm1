function Get-FileExtensionSizeList {
<#
.SYNOPSIS

Returns A Hashtable Consisting of each given file extensions total size in a directory

.DESCRIPTION

Returns A Hashtable Consisting of each given file extensions total size in a directory. 

A directory is required to be passed in as a string, which which will be interated recursively.

A string array with file extensions may also be passed in, if one is not provided a default one will be used with the following
extensions:

TODO: Figure out default extensions

It is recommended that you run 'Get-Help -Name "Get-FileExtensionSizeList" -Detailed' for more information

.PARAMETER Directory
Specifies the Directory which will be recursively scanned. 

.PARAMETER Extensions
Specifies the extensions which will be included in the analysis.
Default Value: TODO

.INPUTS

None. You cannot pipe objects to Get-FileExtensionSizeList.

.OUTPUTS

System.Collections.Hashtable. Get-FileExtensionSizeList returns a hashtable with the following format:
{
    "EXTENSION(String)":{
        "byteSize": INT,
        "percentageOfTotal": DOUBLE
    },
    "EXTENSION(String)":{
        "byteSize": INT,
        "percentageOfTotal": DOUBLE
    }
}

.EXAMPLE
TODO: Do this once Finished
PS> extension -name "File"
File.txt

.LINK
https://github.com/tdorey00/PowerShell_Zone/tree/main/Modules/DirectoryScanner

#>
    [cmdletBinding(PositionalBinding=$false)]
    param (
        #Directory that will be analyzed
        [Parameter(Mandatory=$true)]
        [string]$Directory,
        #Extensions to be analyzed
        [Parameter(Mandatory=$false)]
        [string[]]$Extensions = @()
    )
    Write-Host $Directory
}