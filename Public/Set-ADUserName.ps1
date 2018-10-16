function Set-ADUserName {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)][Microsoft.ActiveDirectory.Management.ADAccount] $User,
        [parameter(Mandatory = $true)][ValidateSet("Before", "After")][String] $Option,
        [string[]] $TextToAdd
    )
    $Object = @()
    if ($TextToAdd -and $User.DisplayName -notlike "*$TextToAdd*") {
        if ($Option -eq 'After') {
            $NewName = "$($User.DisplayName)$TextToAdd"
        } elseif ($Option -eq 'Before') {
            $NewName = "$TextToAdd$($User.DisplayName)"
        }
        if ($NewName -ne $User.DisplayName) {
            #Write-Color @Script:WriteParameters -Text '[i]', ' Renaming user by adding text "', $TextToAdd, '". Name will be added ', $Option, ' Display Name ', $User.DisplayName, '. New expected name: ', $NewName -Color White, Yellow, Green, White, Yellow, White, Yellow, White
            try {
                Set-ADUser -Identity $User -DisplayName $NewName #-WhatIf
                Rename-ADObject -Identity $User -NewName $NewName #-WhatIf
                $Object += @{ Status = $true; Output = $User.SamAccountName; Extended = 'Renamed user.' }
            } catch {
                $ErrorMessage = $_.Exception.Message -replace "`n", " " -replace "`r", " "
                $Object += @{ Status = $false; Output = $User.SamAccountName; Extended = $ErrorMessage }
            }
        }
    }
    return $Object
}