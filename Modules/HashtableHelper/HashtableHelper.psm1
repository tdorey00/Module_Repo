function Convert-PSObjectToHashtable {
<#
.SYNOPSIS

Converts a given PSObject or PSCustomObject into a hashtable.

.DESCRIPTION

Converts a given PSObject or PSCustomObject into a hashtable.

All keys will be at the root level unless the PSObject contains within it objects or hashtables in which case the 
child properties will be added to a parent key. 


It is recommended that you run 'Get-Help -Name "Convert-PSObjectToHashtable" -full' for more information

.PARAMETER InputObject

An Object to be turned into a hashtable

.INPUTS

An Object to be turned into a hashtable.

.OUTPUTS

If given a null value, will return null.

If given an object that is not of type PSObject will return the given object.

If object is of type PSObject will return System.Collections.Hashtable representation of object given.

.EXAMPLE

Given a nested PSCustomObject:

[PSCustomObject]$Obj= @{
    Val1 = "Val1";
    Val2 = "Val2";
    Val3 = [PSCustomObject]@{
        Val4 = "Nested!";
        Val5 = [PSCustomObject]@{
            Val6 = "Hi"
        }
    };
    Val7 = 1231231;
}

[hashtable]$result = Convert-PSObjectToHashtable -InputObject $Obj

$result["Val1"]
$result["Val2"]
$result["Val3"]["Val4"]
$result["Val3"]["Val5"]["Val6"]
$result["Val7"]

Will produce the following output:
Val1
Val2
Nested!
Hi
1231231

.EXAMPLE

Given a PSObject:

$object1 = New-Object -TypeName PSObject
Add-Member -InputObject $object1 -MemberType NoteProperty -Name one -Value 1
Add-Member -InputObject $object1 -MemberType NoteProperty -Name two -Value "Hello World"
[PSCustomObject]$customObj = @{
    nestedProp = "Hi!"
}
Add-Member -InputObject $object1 -MemberType NoteProperty -Name three -Value $customObj

$result = Convert-PSObjectToHashtable -InputObject $object1

$result["one"]
$result["two"]
$result["three"]["nestedProp"]

Will Produce the following results:
1
Hello World
Hi!

.LINK
https://github.com/tdorey00/PowerShell_Zone/tree/main/Modules/HashtableHelper

#>

    [CmdletBinding(PositionalBinding)]
    param (
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        $InputObject
    )

    process {

        if($null -eq $InputObject) { return $null }

        if($InputObject -is [System.Collections.Hashtable]) { 
            # Sometimes PSCustomObjects are also technically Hashtables, so in this case
            # we want to check if the InputObject is a hashtable and then iterate over the Keys
            # and recursively call to build up the return. This also works with regular hashtables which is
            # kind of a neat side effect I suppose.
            
            [System.Collections.Hashtable]$hash = @{}

            foreach($key in $InputObject.keys) {
                $hash[$key] = (Convert-PSObjectToHashtable -InputObject $InputObject[$key])
            }    

            return $hash
        }

        if($InputObject -is [psobject]) {
            # If the InputObject is a PSObject type, iterate over the properties and recursively call
            # with each property to build a hashtable

            [System.Collections.Hashtable]$hash = @{}

            foreach($property in $InputObject.PSObject.properties) {
                $hash[$property.Name] = (Convert-PSObjectToHashtable -InputObject $property.Value)
            }

            return $hash
        }
        else {
            # Base Case and Standard return for non PSObjects, return InputObject
            return $InputObject
        }
    }
}