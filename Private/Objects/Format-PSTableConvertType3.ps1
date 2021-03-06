function Format-PSTableConvertType3 {
    [CmdletBinding()]
    param (
        [Object] $Object,
        [switch] $SkipTitles,
        [string[]] $Property,
        [string[]] $ExcludeProperty,
        [switch] $NoAliasOrScriptProperties,
        [switch] $DisplayPropertySet,
        [Object] $OverwriteHeaders
    )
    #Write-Verbose 'Format-PSTableConvertType3 - Option 3'
    $Array = New-ArrayList
    ### Add Titles
    if (-not $SkipTitles) {
        $Titles = New-ArrayList
        Add-ToArray -List $Titles -Element 'Name'
        Add-ToArray -List $Titles -Element 'Value'
        Add-ToArray -List $Array -Element $Titles
    }
    ### Add Data
    foreach ($O in $Object) {
        foreach ($Name in $O.Keys) {
            # Write-Verbose "Test2 - $Key - $($O[$Key])"
            $ArrayValues = New-ArrayList
            if ($Property) {
                if ($Property -contains $Name) {
                    Add-ToArray -List $ArrayValues -Element $Name
                    Add-ToArray -List $ArrayValues -Element $Object.$Name
                    Add-ToArray -List $Array -Element $ArrayValues
                }
            } else {
                if ($ExcludeProperty -notcontains $Name) {
                    Add-ToArray -List $ArrayValues -Element $Name
                    Add-ToArray -List $ArrayValues -Element $O[$Name]
                    Add-ToArray -List $Array -Element $ArrayValues
                }
            }
        }
    }
    return , $Array
}