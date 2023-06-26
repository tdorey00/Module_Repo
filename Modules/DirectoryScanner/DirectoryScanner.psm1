function Get-FileExtensionSizeList {
<#
.SYNOPSIS

Returns A Hashtable Consisting of each given file extensions total size in a directory

WARNING: SEARCH IS RECURSIVE... Do not give a directory like "C:/" unless you want it to take forever. 

.DESCRIPTION

Returns A Hashtable Consisting of each given file extensions total size in a directory. 

A directory is required to be passed in as a string, which which will be interated recursively.

A string array with file extensions may also be passed in, if one is not provided a default one will be used with the following
extensions:

It is recommended that you run 'Get-Help -Name "Get-FileExtensionSizeList" -Detailed' for more information

.PARAMETER Directory
Specifies the Directory which will be recursively scanned. 

.PARAMETER Extensions
Specifies the extensions which will be included in the analysis, expects string extensions beginning with a '.' if none is provided it will sum all extensions.

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
        #Extensions to be analyzed specifically, otherwise parse all extensions
        [Parameter(Mandatory=$false)]
        [string[]]$Extensions = @()
    )

    Get-DirectoryValidity -Path $Directory

    try{
        [array]$contents = Get-ChildItem -Recurse -Path $Directory -ErrorAction Stop #Get Contents of given Directory
    }
    catch{
        Write-Host "$(Get-Date) - $($MyInvocation.MyCommand) - UNEXPECTED ERROR: $($_.Exception)" -ForegroundColor Red
        Write-Host "DESCRIPTION: $($_.ErrorDetails)" -ForegroundColor Red
        exit
    }

    $files = [System.Collections.ArrayList]@()

    for([int]$i = 0; $i -lt $contents.length; $i++){ #remove directories from the array and add to files
        if($contents[$i].Attributes -ieq "Archive"){ #if the entry in the array is an archive
            $files.Add($contents[$i]) | Out-Null
            Write-Verbose $contents[$i]
        }
    }

    if($null -eq $files -or $files.Count -eq 0){
        Write-Host "$(Get-Date) - $($MyInvocation.MyCommand) - Directory '$($Directory)' contains no files." -ForegroundColor Red
        return $null
    }

    [bool]$parseAll = $Extensions.Count -eq 0

    Write-Host $files.Count
    ##GROUNDWORK IS LAID MAKE IT WORK FOR ALL EXTENSIONS... THEN WE BUILD THE HASHTABLE prob should make it its own helper function
    #$filtered = $files.Where({$_.EXTENSION -eq ".zip"}, 0)
    #foreach($file in $filtered){
    #    Write-Host "File = $($file.Fullname) and $($file.EXTENSION)"
    #}

}

function script:Get-DirectoryValidity{
    # Helper Function
    # Checks Directory Validity: if its a valid path, if it given path actually exists, and makes sure path is a directory not a file
    [cmdletBinding(PositionalBinding=$false)]
    param (
        #Path that will be checked
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if(-not (Test-Path -Path $Path -IsValid)){
        throw "$(Get-Date) - $($MyInvocation.MyCommand) - Provided Directory '$($Path)' is not valid please check the path and try again."
    }
    elseif(-not (Test-Path -Path $Path -PathType Container)){ #Check if path is a Directory or a file
        throw "$(Get-Date) - $($MyInvocation.MyCommand) - Provided Path '$($Path)' is not a valid Directory or is a file path please enter a valid Directory and not a file path."
    }

}