function Convert-PSObjectToHashtable {

    [OutputType([System.Collections.Hashtable])]
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