Import-Module -Name $PSScriptRoot\HashtableHelper -Force

$object1 = New-Object -TypeName PSObject
Add-Member -InputObject $object1 -MemberType NoteProperty -Name one -Value 1
Add-Member -InputObject $object1 -MemberType NoteProperty -Name two -Value "Hello World"
[PSCustomObject]$customObj = @{
    nestedProp = "Hi!"
}
Add-Member -InputObject $object1 -MemberType NoteProperty -Name three -Value $customObj

$result = $object1 | Convert-PSObjectToHashtable

$result["three"]["nestedProp"]